defmodule IstWeb.SessionViewTest do
  use IstWeb.ConnCase, async: true

  import Phoenix.View

  alias IstWeb.SessionView

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(IstWeb.Router, :browser)
      |> get("/")

    {:ok, %{conn: conn}}
  end

  test "renders new.html", %{conn: conn} do
    content = render_to_string(SessionView, "new.html", conn: conn)

    assert String.contains?(content, "Login")
  end
end
