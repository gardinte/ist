defmodule IstWeb.DeviceViewTest do
  use IstWeb.ConnCase, async: true

  alias IstWeb.DeviceView
  alias Ist.Recorder
  alias Ist.Recorder.Device

  import Phoenix.View
  import Phoenix.HTML, only: [safe_to_string: 1]

  test "renders index.html", %{conn: conn} do
    page = %Scrivener.Page{total_pages: 1, page_number: 1}

    devices = [
      %Device{
        id: "1",
        name: "Camera 1",
        description: "Lobby",
        status: "recording",
        url: "rtsp://localhost/camera_1"
      },
      %Device{
        id: "2",
        name: "Camera 2",
        description: nil,
        status: "starting",
        url: "rtsp://localhost/camera_2"
      }
    ]

    content = render_to_string(DeviceView, "index.html", conn: conn, devices: devices, page: page)

    for device <- devices do
      assert String.contains?(content, device.name)
    end
  end

  test "renders new.html", %{conn: conn} do
    changeset = test_account() |> Recorder.change_device(%Device{})
    content = render_to_string(DeviceView, "new.html", conn: conn, changeset: changeset)

    assert String.contains?(content, "New device")
  end

  test "renders edit.html", %{conn: conn} do
    device = %Device{
      id: "1",
      name: "Camera 1",
      description: "Lobby",
      status: "recording",
      url: "rtsp://localhost/camera_1"
    }

    changeset = test_account() |> Recorder.change_device(device)

    content =
      render_to_string(DeviceView, "edit.html",
        conn: conn,
        device: device,
        changeset: changeset
      )

    assert String.contains?(content, device.name)
  end

  test "renders show.html", %{conn: conn} do
    device = %Device{
      id: "1",
      name: "Camera 1",
      description: "Lobby",
      status: "recording",
      url: "rtsp://localhost/camera_1"
    }

    content = render_to_string(DeviceView, "show.html", conn: conn, device: device)

    assert String.contains?(content, device.name)
  end

  test "show description" do
    assert DeviceView.show_description?(%Device{description: "test"})
    refute DeviceView.show_description?(%Device{description: nil})
    refute DeviceView.show_description?(%Device{description: " \n "})
  end

  test "status" do
    device = %Device{
      id: "1",
      name: "Camera 1",
      description: "Lobby",
      status: "recording",
      url: "rtsp://localhost/camera_1"
    }

    content = device |> DeviceView.status() |> safe_to_string()

    assert content =~ "Recording"
    assert content =~ "is-success"
    assert content =~ "is-normal"
  end

  defp test_account do
    %Ist.Accounts.Account{db_prefix: "test_account"}
  end
end
