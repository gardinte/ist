defmodule IstWeb.SessionPlug do
  import Phoenix.Controller
  import Plug.Conn
  import IstWeb.Gettext

  alias Ist.Accounts
  alias IstWeb.Router.Helpers

  def fetch_current_session(%{assigns: %{current_session: session}} = conn, _opts)
      when is_map(session),
      do: conn

  def fetch_current_session(conn, _opts) do
    account_id = get_session(conn, :account_id)
    user_id = get_session(conn, :user_id)
    session = Accounts.get_current_session(account_id, user_id)

    assign(conn, :current_session, session)
  end

  def authenticate(%{assigns: %{current_session: session}} = conn, _opts)
      when is_map(session),
      do: conn

  def authenticate(conn, _opts) do
    conn
    |> put_return_path()
    |> put_flash(:error, dgettext("sessions", "You must be logged in."))
    |> redirect(to: Helpers.session_path(conn, :new))
    |> halt()
  end

  defp put_return_path(%{method: "GET", request_path: request_path} = conn)
       when request_path != "/" do
    put_session(conn, :previous_url, current_path(conn))
  end

  defp put_return_path(conn), do: conn
end
