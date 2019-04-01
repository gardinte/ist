defmodule IstWeb.SessionController do
  use IstWeb, :controller

  plug(:authenticate when action in [:delete])

  def new(%{assigns: %{current_session: session}} = conn, _params)
      when is_map(session) do
    redirect(conn, to: Routes.root_path(conn, :index))
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Ist.Accounts.authenticate_by_email_and_password(email, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("Welcome!"))
        |> put_session(:user_id, user.id)
        |> put_session(:account_id, user.account_id)
        |> configure_session(renew: true)
        |> redirect_to_next_path()

      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, dgettext("sessions", "Invalid email/password combination"))
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> clear_session()
    |> put_flash(:info, gettext("See you soon!"))
    |> redirect(to: Routes.root_path(conn, :index))
  end

  defp redirect_to_next_path(conn) do
    path = get_session(conn, :previous_url) || Routes.root_path(conn, :index)

    conn
    |> delete_session(:previous_url)
    |> redirect(to: path)
  end
end
