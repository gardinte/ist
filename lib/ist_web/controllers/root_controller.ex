defmodule IstWeb.RootController do
  use IstWeb, :controller

  def index(%{assigns: %{current_session: session}} = conn, _params)
      when is_map(session) do
    redirect(conn, to: Routes.device_path(conn, :index))
  end

  def index(conn, _params) do
    redirect(conn, to: Routes.session_path(conn, :new))
  end
end
