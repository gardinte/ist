defmodule IstWeb.PasswordController do
  use IstWeb, :controller

  alias Ist.Accounts
  alias Ist.Accounts.{Password, User}

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"email" => email}}) do
    case Accounts.get_user(email: email) do
      %User{} = user ->
        {:ok, _} = Password.reset(user)

        conn
        |> put_flash(:info, dgettext("passwords", "Password reset instructions sent"))
        |> redirect(to: root_path(conn, :index))

      nil ->
        conn
        |> put_flash(:error, dgettext("passwords", "Email not found"))
        |> render("new.html")
    end
  end

  def edit(conn, %{"id" => token}) do
    case Accounts.get_user(token: token) do
      %User{} = user ->
        changeset = Accounts.change_user_password(user)

        render(conn, "edit.html", token: token, changeset: changeset)

      nil ->
        handle_invalid_token(conn)
    end
  end

  def update(conn, %{"id" => token, "user" => password_params}) do
    case Accounts.get_user(token: token) do
      %User{} = user ->
        case Accounts.update_user_password(user, password_params) do
          {:ok, _} ->
            conn
            |> put_flash(:info, dgettext("passwords", "Password updated successfully"))
            |> redirect(to: root_path(conn, :index))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit.html", token: token, changeset: changeset)
        end

      nil ->
        handle_invalid_token(conn)
    end
  end

  defp handle_invalid_token(conn) do
    conn
    |> put_flash(:error, dgettext("passwords", "Token invalid or expired"))
    |> redirect(to: root_path(conn, :index))
  end
end
