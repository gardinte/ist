defmodule Ist.Accounts.SessionTest do
  use Ist.DataCase

  alias Ist.Accounts.Session

  describe "session" do
    test "get_session/2 returns the session with given account and user id" do
      {:ok, user, account} = fixture(:user)
      %Session{} = session = Session.get_session(account.id, user.id)

      assert user == session.user
      assert account == session.account
    end

    test "get_session/2 returns nil when any argument is nil" do
      refute Session.get_session(nil, 1)
      refute Session.get_session(1, nil)
      refute Session.get_session(nil, nil)
    end
  end
end
