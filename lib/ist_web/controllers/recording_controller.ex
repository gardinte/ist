defmodule IstWeb.RecordingController do
  use IstWeb, :controller

  alias Ist.Recorder

  plug :authenticate
  plug :put_breadcrumb, name: dgettext("devices", "Devices"), url: "/devices"

  def action(%{assigns: %{current_session: session}} = conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, session])
  end

  def index(conn, %{"device_id" => device_id} = params, session) do
    device = Recorder.get_device!(session.account, device_id)
    page = Recorder.list_recordings(session.account, device, params)

    conn
    |> put_device_breadcrumb(device)
    |> put_recordings_breadcrumb(device, active: true)
    |> render_index(page, device)
  end

  def show(conn, %{"id" => id, "device_id" => device_id}, session) do
    device = Recorder.get_device!(session.account, device_id)
    recording = Recorder.get_recording!(session.account, device, id)

    conn
    |> put_device_breadcrumb(device)
    |> put_recordings_breadcrumb(device)
    |> put_show_breadcrumb(recording, device)
    |> render("show.html", device: device, recording: recording)
  end

  def delete(conn, %{"id" => id, "device_id" => device_id}, session) do
    device = Recorder.get_device!(session.account, device_id)
    recording = Recorder.get_recording!(session.account, device, id)
    {:ok, _recording} = Recorder.delete_recording(session, recording)

    conn
    |> put_flash(:info, dgettext("recordings", "Recording deleted successfully."))
    |> redirect(to: Routes.device_recording_path(conn, :index, device))
  end

  defp render_index(conn, %{total_entries: 0}, device) do
    render(conn, "empty.html", device: device)
  end

  defp render_index(conn, page, device) do
    render(conn, "index.html", device: device, recordings: page.entries, page: page)
  end

  defp put_show_breadcrumb(conn, recording, device) do
    name = dgettext("recordings", "Recording")
    url = Routes.device_recording_path(conn, :show, device, recording)

    conn |> put_breadcrumb(name, url)
  end

  defp put_recordings_breadcrumb(conn, device, opts \\ []) do
    name = dgettext("recordings", "Recordings")
    url = Routes.device_recording_path(conn, :index, device)
    opts = Keyword.merge([name: name, url: url], opts)

    conn |> put_breadcrumb(opts)
  end

  defp put_device_breadcrumb(conn, device) do
    name = device.name
    url = Routes.device_path(conn, :show, device)

    conn |> put_breadcrumb(name: name, url: url)
  end
end
