defmodule Ist.Helpers do
  alias Ist.Accounts

  def prefixed(query, account) do
    query
    |> Ecto.Queryable.to_query()
    |> Map.put(:prefix, Accounts.prefix(account))
  end
end
