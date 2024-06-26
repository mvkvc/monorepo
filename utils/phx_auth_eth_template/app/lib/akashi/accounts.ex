defmodule Akashi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Akashi.Repo

  alias Akashi.Accounts.{User, UserToken, UserNotifier}

  def get_user_by_eth_address(nil), do: nil
  def get_user_by_eth_address(eth_address), do: Repo.get_by(User, eth_address: eth_address)

  def generate_account_nonce do
    :crypto.strong_rand_bytes(10)
    |> Base.encode16()
  end

  def update_user_nonce(eth_address) do
    user = get_user_by_eth_address(eth_address)

    attrs = %{
      "eth_address" => eth_address,
      "nonce" => generate_account_nonce()
    }

    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def create_user(attrs) do
    IO.inspect(attrs, label: "attrs in create_user")

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def create_user_if_not_exists(address) do
    attrs = %{
      "eth_address" => address,
      "eth_nonce" => generate_account_nonce()
    }

    case get_user_by_eth_address(address) do
      nil ->
        IO.inspect("create_user_if_not_exists")
        create_user(attrs)

      user ->
        {:ok, user}
    end
  end

  def find_user_by_public_address(eth_address) do
    Repo.get_by(User, eth_address: eth_address)
  end

  def verify_message_signature(eth_address, signature) do
    IO.puts("verify_message_signature")

    with user = %User{} <- find_user_by_public_address(eth_address) do
      IO.inspect(user, label: "user")
      message = "You are signing this message to sign in with Akashi. Nonce: #{user.eth_nonce}"
      IO.inspect(message, label: "message")

      signing_address = ExWeb3EcRecover.recover_personal_signature(message, signature)
      IO.inspect(signing_address, label: "signing_address")
      IO.inspect(eth_address, label: "eth_address")

      if String.downcase(signing_address) == String.downcase(eth_address) do
        update_user_nonce(eth_address)
        user
      end
    end
  end

  ## Database getters

  @doc """
  Gets a user by email.

  ## Examples

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """

  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  ## User registration

  @doc """
  Registers a user.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user_registration(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_registration(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs, validate_email: false)
  end

  ## Settings

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user email.

  ## Examples

      iex> change_user_email(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_email(user, attrs \\ %{}) do
    User.email_changeset(user, attrs, validate_email: false)
  end

  @doc """
  Emulates that the email will change without actually changing
  it in the database.

  <!-- DOES NOT USE PASSWORD ANYMORE -->

  ## Examples

      iex> apply_user_email(user, "valid password", %{email: ...})
      {:ok, %User{}}

      iex> apply_user_email(user, "invalid password", %{email: ...})
      {:error, %Ecto.Changeset{}}

  """
  def apply_user_email(user, attrs) do
    user
    |> User.email_changeset(attrs)
    |> Ecto.Changeset.apply_action(:update)
  end

  @doc """
  Updates the user email using the given token.

  If the token matches, the user email is updated and the token is deleted.
  The confirmed_at date is also updated to the current time.
  """
  def update_user_email(user, token) do
    context = "change:#{user.email}"

    with {:ok, query} <- UserToken.verify_change_email_token_query(token, context),
         %UserToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(user_email_multi(user, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp user_email_multi(user, email, context) do
    changeset =
      user
      |> User.email_changeset(%{email: email})
      # |> User.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, [context]))
  end

  @doc ~S"""
  Delivers the update email instructions to the given user.

  ## Examples

      iex> deliver_user_update_email_instructions(user, current_email, &url(~p"/users/settings/confirm_email/#{&1})")
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_user_update_email_instructions(%User{} = user, current_email, update_email_url_fun)
      when is_function(update_email_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "change:#{current_email}")

    Repo.insert!(user_token)
    UserNotifier.deliver_update_email_instructions(user, update_email_url_fun.(encoded_token))
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_user_session_token(token) do
    Repo.delete_all(UserToken.token_and_context_query(token, "session"))
    :ok
  end
end
