defmodule IstWeb.DeviceView do
  use IstWeb, :view
  use Scrivener.HTML

  alias Ist.Recorder.Device

  def link_to_show(conn, device) do
    icon_link("eye",
      title: dgettext("devices", "Show"),
      to: Routes.device_path(conn, :show, device),
      class: "button is-small is-outlined"
    )
  end

  def link_to_edit(conn, device) do
    icon_link("pencil-alt",
      title: dgettext("devices", "Edit"),
      to: Routes.device_path(conn, :edit, device),
      class: "button is-small is-outlined is-hidden-mobile"
    )
  end

  def link_to_delete(conn, device) do
    icon_link("trash",
      title: dgettext("devices", "Delete"),
      to: Routes.device_path(conn, :delete, device),
      method: :delete,
      data: [confirm: dgettext("devices", "Are you sure?")],
      class: "button is-small is-danger is-outlined"
    )
  end

  def lock_version_input(_, nil), do: nil

  def lock_version_input(form, device) do
    hidden_input(form, :lock_version, value: device.lock_version)
  end

  def submit_button(device) do
    submit_label(device)
    |> submit(class: "button is-medium is-white is-paddingless card-footer-item")
  end

  def show_description?(%Device{description: nil}), do: false

  def show_description?(%Device{description: description}) do
    String.trim(description) != ""
  end

  def status(device, size_class \\ "is-normal") do
    status_text =
      %{
        "unknown" => dgettext("devices", "Unknown"),
        "starting" => dgettext("devices", "Starting"),
        "recording" => dgettext("devices", "Recording"),
        "failing" => dgettext("devices", "Failing"),
        "stopped" => dgettext("devices", "Stopped")
      }[device.status]

    tag_class =
      %{
        "unknown" => "is-light",
        "starting" => "is-info",
        "recording" => "is-success",
        "failing" => "is-danger",
        "stopped" => "is-dark"
      }[device.status]

    content_tag(:span, status_text, class: "tag #{tag_class} #{size_class}")
  end

  defp submit_label(nil), do: dgettext("devices", "Create")
  defp submit_label(_), do: dgettext("devices", "Update")
end
