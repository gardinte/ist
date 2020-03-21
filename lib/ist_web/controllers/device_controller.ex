defmodule IstWeb.DeviceController do
  use IstWeb, :controller

  alias Ist.Recorder
  alias Ist.Recorder.Device

  plug :authenticate
  plug :put_breadcrumb, name: dgettext("devices", "Devices"), url: "/devices"

  def action(%{assigns: %{current_session: session}} = conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, session])
  end

  def index(conn, params, session) do
    page = Recorder.list_devices(session.account, params)

    render_index(conn, page)
  end

  def new(conn, _params, session) do
    changeset = Recorder.change_device(session.account, %Device{})

    conn
    |> put_new_breadcrumb
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"device" => device_params}, session) do
    case Recorder.create_device(session, device_params) do
      {:ok, device} ->
        conn
        |> put_flash(:info, dgettext("devices", "Device created successfully."))
        |> redirect(to: Routes.device_path(conn, :show, device))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, session) do
    device = Recorder.get_device!(session.account, id)

    conn
    |> put_show_breadcrumb(device)
    |> render("show.html", device: device)
  end

  def edit(conn, %{"id" => id}, session) do
    device = Recorder.get_device!(session.account, id)
    changeset = Recorder.change_device(session.account, device)

    conn
    |> put_edit_breadcrumb(device)
    |> render("edit.html", device: device, changeset: changeset)
  end

  def update(conn, %{"id" => id, "device" => device_params}, session) do
    device = Recorder.get_device!(session.account, id)

    case Recorder.update_device(session, device, device_params) do
      {:ok, device} ->
        conn
        |> put_flash(:info, dgettext("devices", "Device updated successfully."))
        |> redirect(to: Routes.device_path(conn, :show, device))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", device: device, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, session) do
    device = Recorder.get_device!(session.account, id)
    {:ok, _device} = Recorder.delete_device(session, device)

    conn
    |> put_flash(:info, dgettext("devices", "Device deleted successfully."))
    |> redirect(to: Routes.device_path(conn, :index))
  end

  defp render_index(conn, %{total_entries: 0}), do: render(conn, "empty.html")

  defp render_index(conn, page) do
    render(conn, "index.html", devices: page.entries, page: page)
  end

  defp put_new_breadcrumb(conn) do
    name = dgettext("devices", "New device")
    url = Routes.device_path(conn, :new)

    conn |> put_breadcrumb(name, url)
  end

  defp put_show_breadcrumb(conn, device) do
    name = device.name
    url = Routes.device_path(conn, :show, device)

    conn |> put_breadcrumb(name, url)
  end

  defp put_edit_breadcrumb(conn, device) do
    name = dgettext("devices", "Edit device")
    url = Routes.device_path(conn, :edit, device)

    conn |> put_breadcrumb(name, url)
  end
end
