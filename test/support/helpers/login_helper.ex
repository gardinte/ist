defmodule Ist.Support.LoginHelper do
  use ExUnit.CaseTemplate
  use Phoenix.ConnTest

  import Ist.Support.FixtureHelper

  alias Ist.Accounts.{Session, User}

  using do
    quote do
      import Ist.Support.LoginHelper

      setup %{conn: conn} = config do
        do_setup(conn, config[:login_as])
      end
    end
  end

  def do_setup(_, nil), do: :ok

  def do_setup(conn, email) do
    account = fixture(:seed_account)
    user = %User{email: email, account_id: account.id}
    session = %Session{account: account, user: user}
    conn = assign(conn, :current_session, session)

    {:ok, conn: conn, account: account, user: user}
  end
end
