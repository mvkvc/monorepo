defmodule TreeFi.PaymentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TreeFi.Payments` context.
  """

  @doc """
  Generate a accounts.
  """
  def accounts_fixture(attrs \\ %{}) do
    {:ok, accounts} =
      attrs
      |> Enum.into(%{
        denomination: "some denomination"
      })
      |> TreeFi.Payments.create_accounts()

    accounts
  end

  @doc """
  Generate a transactions.
  """
  def transactions_fixture(attrs \\ %{}) do
    {:ok, transactions} =
      attrs
      |> Enum.into(%{
        amount: 42,
        denomination: "some denomination"
      })
      |> TreeFi.Payments.create_transactions()

    transactions
  end
end
