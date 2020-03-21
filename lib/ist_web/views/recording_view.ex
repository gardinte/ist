defmodule IstWeb.RecordingView do
  use IstWeb, :view
  use Scrivener.HTML

  def link_to_show(conn, device, recording) do
    icon_link("eye",
      title: dgettext("recordings", "Show"),
      to: Routes.device_recording_path(conn, :show, device, recording),
      class: "button is-small is-outlined"
    )
  end

  def link_to_delete(conn, device, recording) do
    icon_link("trash",
      title: dgettext("recordings", "Delete"),
      to: Routes.device_recording_path(conn, :delete, device, recording),
      method: :delete,
      data: [confirm: dgettext("recordings", "Are you sure?")],
      class: "button is-small is-danger is-outlined"
    )
  end

  def refresh_link(conn, device) do
    path = Routes.device_recording_path(conn, :index, device)

    dgettext("recordings", "refresh")
    |> link(to: path)
    |> safe_to_string()
  end

  def device_link(conn, device) do
    path = Routes.device_path(conn, :show, device)

    device.name
    |> link(to: path)
    |> safe_to_string()
  end
end
