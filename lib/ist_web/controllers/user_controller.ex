defmodule IstWeb.UserController do
  use IstWeb, :controller

  alias Ist.Accounts
  alias Ist.Accounts.User

  plug(:authenticate)
  plug(:put_breadcrumb, name: dgettext("users", "Users"), url: "/users")

  def action(%{assigns: %{current_session: session}} = conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, session])
  end

  def index(conn, params, session) do
    page = Accounts.list_users(session.account, params)

    render(conn, "index.html", users: page.entries, page: page)
  end

  def new(conn, _params, _session) do
    changeset = Accounts.change_user(%User{})

    conn
    |> put_new_breadcrumb
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}, session) do
    case Accounts.create_user(session, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, dgettext("users", "User created successfully."))
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, session) do
    user = Accounts.get_user!(session.account, id)

    conn
    |> put_show_breadcrumb(user)
    |> render("show.html", user: user)
  end

  def edit(conn, %{"id" => id}, session) do
    user = Accounts.get_user!(session.account, id)
    changeset = Accounts.change_user(user)

    conn
    |> put_edit_breadcrumb(user)
    |> render("edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}, session) do
    user = Accounts.get_user!(session.account, id)

    case Accounts.update_user(session, user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, dgettext("users", "User updated successfully."))
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, session) do
    user = Accounts.get_user!(session.account, id)
    {:ok, _user} = Accounts.delete_user(session, user)

    conn
    |> put_flash(:info, dgettext("users", "User deleted successfully."))
    |> redirect(to: Routes.user_path(conn, :index))
  end

  defp put_new_breadcrumb(conn) do
    name = dgettext("users", "New user")
    url = Routes.user_path(conn, :new)

    conn |> put_breadcrumb(name, url)
  end

  defp put_show_breadcrumb(conn, user) do
    name = dgettext("users", "User")
    url = Routes.user_path(conn, :show, user)

    conn |> put_breadcrumb(name, url)
  end

  defp put_edit_breadcrumb(conn, user) do
    name = dgettext("users", "Edit user")
    url = Routes.user_path(conn, :edit, user)

    conn |> put_breadcrumb(name, url)
  end
end
