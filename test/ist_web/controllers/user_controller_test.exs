defmodule IstWeb.UserControllerTest do
  use IstWeb.ConnCase
  use Ist.Support.LoginHelper

  import Ist.Support.FixtureHelper

  @create_attrs %{
    email: "some@email.com",
    lastname: "some lastname",
    name: "some name",
    password: "123456"
  }
  @update_attrs %{
    email: "new@email.com",
    lastname: "some updated lastname",
    name: "some updated name"
  }
  @invalid_attrs %{email: "wrong@email", lastname: nil, name: nil, password: "123"}

  describe "unauthorized access" do
    test "requires user authentication on all actions", %{conn: conn} do
      Enum.each(
        [
          get(conn, user_path(conn, :index)),
          get(conn, user_path(conn, :new)),
          post(conn, user_path(conn, :create, %{})),
          get(conn, user_path(conn, :show, "123")),
          get(conn, user_path(conn, :edit, "123")),
          put(conn, user_path(conn, :update, "123", %{})),
          delete(conn, user_path(conn, :delete, "123"))
        ],
        fn conn ->
          assert html_response(conn, 302)
          assert conn.halted
        end
      )
    end
  end

  describe "index" do
    @tag login_as: "test@user.com"
    test "lists all users", %{conn: conn} do
      conn = get(conn, user_path(conn, :index))

      assert html_response(conn, 200) =~ "Users"
    end
  end

  describe "new user" do
    @tag login_as: "test@user.com"
    test "renders form", %{conn: conn} do
      conn = get(conn, user_path(conn, :new))

      assert html_response(conn, 200) =~ "New user"
    end
  end

  describe "create user" do
    @tag login_as: "test@user.com"
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, user_path(conn, :create), user: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == user_path(conn, :show, id)
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, user_path(conn, :create), user: @invalid_attrs)

      assert html_response(conn, 200)
    end
  end

  describe "edit user" do
    setup [:create_user]

    @tag login_as: "test@user.com"
    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, user_path(conn, :edit, user))

      assert html_response(conn, 200) =~ ~r/#{user.email}/
    end
  end

  describe "update user" do
    setup [:create_user]

    @tag login_as: "test@user.com"
    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put(conn, user_path(conn, :update, user), user: @update_attrs)

      assert redirected_to(conn) == user_path(conn, :show, user)
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, user_path(conn, :update, user), user: @invalid_attrs)

      assert html_response(conn, 200)
    end
  end

  describe "delete user" do
    setup [:create_user]

    @tag login_as: "test@user.com"
    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, user_path(conn, :delete, user))

      assert redirected_to(conn) == user_path(conn, :index)
    end
  end

  defp create_user(%{account: account}) do
    {:ok, user, _} = fixture(:user, @create_attrs, account)

    {:ok, user: user}
  end
end
