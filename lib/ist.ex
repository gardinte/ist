defmodule Ist do
  @moduledoc """
  Ist keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def migration do
    quote do
      use Ecto.Migration
      import Ist.Accounts.Migration
    end
  end

  @doc """
  When used, dispatch to the appropriate migration/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
