defmodule IstWeb.LayoutView do
  use IstWeb, :view

  import Phoenix.Controller, only: [get_flash: 1, current_path: 1]

  def locale do
    IstWeb.Gettext
    |> Gettext.get_locale()
    |> String.replace(~r/_\w+/, "")
  end

  def render_flash(conn, template \\ "_flash.html") do
    case get_flash_message(conn) do
      {type, message} ->
        render(template, conn: conn, type: type, message: message)

      nil ->
        ""
    end
  end

  def menu_item(conn, [to: to], do: content) do
    current = current_path(conn)

    html_class =
      if String.starts_with?(current, to) do
        "navbar-item is-active"
      else
        "navbar-item"
      end

    link(to: to, class: html_class, do: content)
  end

  def flash_class("info"), do: "is-info"
  def flash_class("error"), do: "is-danger"

  defp get_flash_message(conn) do
    conn
    |> get_flash()
    |> Enum.at(0)
  end
end
