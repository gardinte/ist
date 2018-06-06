defmodule <%= inspect context.module %> do
  @moduledoc """
  The <%= context.name %> context.
  """

  import Ecto.Query, warn: false
  import <%= inspect context.base_module %>.Accounts.Account, only: [prefix: 1]
  import <%= inspect context.base_module %>.Helpers

  alias <%= inspect schema.repo %>
  alias <%= inspect context.base_module %>.Trail
  alias <%= inspect context.base_module %>.Accounts.{Account, Session}
end
