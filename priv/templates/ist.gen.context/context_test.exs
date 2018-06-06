defmodule <%= inspect context.module %>Test do
  use <%= inspect context.base_module %>.DataCase

  alias <%= inspect context.module %>
  alias <%= inspect context.base_module %>.Accounts.Session
end
