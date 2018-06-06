defmodule IstWeb.RootControllerTest do
  use IstWeb.ConnCase
  use Ist.Support.LoginHelper

  describe "index" do
    test "redirect to new session", %{conn: conn} do
      conn = get(conn, root_path(conn, :index))

      assert redirected_to(conn) == session_path(conn, :new)
    end

    @tag login_as: "test@user.com"
    test "redirect to user's index when logged in", %{conn: conn} do
      conn = get(conn, root_path(conn, :index))

      assert redirected_to(conn) == user_path(conn, :index)
    end
  end
end
