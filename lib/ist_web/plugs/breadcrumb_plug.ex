defmodule IstWeb.BreadcrumbPlug do
  def put_breadcrumb(conn, opts) do
    breadcrumb = %{name: opts[:name], url: opts[:url], active: opts[:active]}

    breadcrumbs =
      Map.get(conn.assigns, :breadcrumbs, [])
      |> Enum.concat([breadcrumb])

    %{conn | assigns: Map.put(conn.assigns, :breadcrumbs, breadcrumbs)}
  end

  def put_breadcrumb(conn, name, url) do
    put_breadcrumb(conn, name: name, url: url, active: true)
  end
end
