defmodule IstWeb.SessionPlugTest do
  use IstWeb.ConnCase

  import Ist.Support.FixtureHelper

  alias IstWeb.SessionPlug

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(IstWeb.Router, :browser)
      |> get("/")

    {:ok, %{conn: conn}}
  end

  describe "session" do
    test "fetch current session", %{conn: conn} do
      {:ok, user, account} = fixture(:user)

      refute conn.assigns.current_session

      login_conn =
        conn
        |> put_session(:account_id, account.id)
        |> put_session(:user_id, user.id)
        |> SessionPlug.fetch_current_session([])
        |> send_resp(:ok, "")

      next_conn = get(login_conn, "/")

      assert next_conn.assigns.current_session.user == user
      assert next_conn.assigns.current_session.account == account
    end

    test "fetch continues when current session exists", %{conn: conn} do
      refute conn.assigns.current_session

      conn =
        conn
        |> assign(:current_session, %Ist.Accounts.Session{})
        |> SessionPlug.fetch_current_session([])

      assert conn.assigns.current_session
    end

    test "fetch no session if no user_id on session", %{conn: conn} do
      conn = SessionPlug.fetch_current_session(conn, [])

      refute conn.assigns.current_session
    end
  end

  describe "authentication" do
    test "authenticate halts when no current session exists", %{conn: conn} do
      refute conn.halted

      conn = SessionPlug.authenticate(conn, [])

      assert conn.halted
      refute get_session(conn, :previous_url)
    end

    test "authenticate continues when current session exists", %{conn: conn} do
      conn =
        conn
        |> assign(:current_session, %Ist.Accounts.Session{})
        |> SessionPlug.authenticate([])

      refute conn.halted
    end

    test "authenticate stores request path when no current session exists", %{conn: conn} do
      refute conn.halted

      conn = SessionPlug.authenticate(%{conn | request_path: "/test"}, [])

      assert conn.halted
      assert get_session(conn, :previous_url) == "/test"
    end
  end
end
