defmodule IstWeb.SessionControllerTest do
  use IstWeb.ConnCase

  import Ist.Support.FixtureHelper

  @valid_user %{
    email: "some@email.com",
    lastname: "some lastname",
    name: "some name",
    password: "123456"
  }
  @invalid_user %{email: "wrong@email.com", password: "wrong"}

  describe "unauthorized access" do
    test "requires user on delete", %{conn: conn} do
      conn = delete(conn, Routes.session_path(conn, :delete))

      assert html_response(conn, 302)
      assert conn.halted
    end
  end

  describe "new session" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :new))

      assert html_response(conn, 200) =~ ~r/Login/
    end

    test "redirects when current session", %{conn: conn} do
      conn =
        conn
        |> assign(:current_session, %Ist.Accounts.Session{})
        |> get(Routes.session_path(conn, :new))

      assert redirected_to(conn) == Routes.root_path(conn, :index)
    end
  end

  describe "create session" do
    test "assigns current user when credentials are valid", %{conn: conn} do
      {:ok, user, _} = fixture(:user, @valid_user)
      conn = post(conn, Routes.session_path(conn, :create), session: @valid_user)

      assert user.id == get_session(conn, :user_id)
      assert user.account_id == get_session(conn, :account_id)
      assert redirected_to(conn) == Routes.root_path(conn, :index)
    end

    # TODO: implement some sort of check for this
    @tag :skip
    test "redirects to previous_url when credentials are valid", %{conn: conn} do
      conn =
        conn
        |> bypass_through(IstWeb.Router, :browser)
        |> get("/")
        |> put_session(:previous_url, "/test")

      {:ok, user, _} = fixture(:user, @valid_user)
      conn = post(conn, Routes.session_path(conn, :create), session: @valid_user)

      assert user.id == get_session(conn, :user_id)
      assert redirected_to(conn) == "/test"
    end

    test "renders errors when credentials are invalid", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), session: @invalid_user)

      refute get_session(conn, :user_id)
      refute get_session(conn, :account_id)
      assert html_response(conn, 200)
      assert get_flash(conn, :error) =~ ~r/Invalid/
    end
  end

  describe "delete" do
    test "clear session", %{conn: conn} do
      conn =
        conn
        |> assign(:current_session, %Ist.Accounts.Session{})
        |> delete(Routes.session_path(conn, :delete))

      refute get_session(conn, :user_id)
      refute get_session(conn, :account_id)
      assert get_flash(conn, :info)
      assert redirected_to(conn) == Routes.root_path(conn, :index)
    end
  end
end
