defmodule TreeFi.Payments do
  @moduledoc """
  The Payments context.
  """

  import Ecto.Query, warn: false
  alias TreeFi.Repo

  alias TreeFi.Payments.Account

  @doc """
  Returns the list of account.

  ## Examples

      iex> list_account()
      [%Account{}, ...]

  """
  def list_account do
    Repo.all(Account)
  end

  @doc """
  Gets a single accounts.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_accounts!(123)
      %Account{}

      iex> get_accounts!(456)
      ** (Ecto.NoResultsError)

  """
  def get_accounts!(id), do: Repo.get!(Account, id)

  @doc """
  Creates a accounts.

  ## Examples

      iex> create_accounts(%{field: value})
      {:ok, %Account{}}

      iex> create_accounts(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_accounts(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a accounts.

  ## Examples

      iex> update_accounts(accounts, %{field: new_value})
      {:ok, %Account{}}

      iex> update_accounts(accounts, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_accounts(%Account{} = accounts, attrs) do
    accounts
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a accounts.

  ## Examples

      iex> delete_accounts(accounts)
      {:ok, %Account{}}

      iex> delete_accounts(accounts)
      {:error, %Ecto.Changeset{}}

  """
  def delete_accounts(%Account{} = accounts) do
    Repo.delete(accounts)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking accounts changes.

  ## Examples

      iex> change_accounts(accounts)
      %Ecto.Changeset{data: %Account{}}

  """
  def change_accounts(%Account{} = accounts, attrs \\ %{}) do
    Account.changeset(accounts, attrs)
  end

  alias TreeFi.Payments.Transaction

  @doc """
  Returns the list of transaction.

  ## Examples

      iex> list_transaction()
      [%Transaction{}, ...]

  """
  def list_transaction do
    Repo.all(Transaction)
  end

  @doc """
  Gets a single transactions.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transactions!(123)
      %Transaction{}

      iex> get_transactions!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transactions!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transactions.

  ## Examples

      iex> create_transactions(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transactions(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transactions(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transactions.

  ## Examples

      iex> update_transactions(transactions, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transactions(transactions, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transactions(%Transaction{} = transactions, attrs) do
    transactions
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transactions.

  ## Examples

      iex> delete_transactions(transactions)
      {:ok, %Transaction{}}

      iex> delete_transactions(transactions)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transactions(%Transaction{} = transactions) do
    Repo.delete(transactions)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transactions changes.

  ## Examples

      iex> change_transactions(transactions)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transactions(%Transaction{} = transactions, attrs \\ %{}) do
    Transaction.changeset(transactions, attrs)
  end
end
