defmodule Ist.Accounts.Migration do
  alias Ist.Repo
  alias Ist.Accounts
  alias Ist.Accounts.Account

  @doc """
  Returns a `List` of all account prefixes.

  ## Examples

      iex> account_prefixes()
      ["t_one", ...]

  """
  def account_prefixes do
    Account
    |> Repo.all()
    |> Enum.map(&Accounts.prefix(&1))
  end
end
