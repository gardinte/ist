defmodule Ist.Helpers do
  alias Ist.Accounts

  defmacro coalesce(left, right) do
    quote do
      fragment("coalesce(?, ?)", unquote(left), unquote(right))
    end
  end

  def prefixed(query, account) do
    query
    |> Ecto.Queryable.to_query()
    |> Map.put(:prefix, Accounts.prefix(account))
  end
end
