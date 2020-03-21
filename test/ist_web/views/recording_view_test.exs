defmodule IstWeb.RecordingViewTest do
  use IstWeb.ConnCase, async: true

  alias IstWeb.RecordingView
  alias Ist.Recorder.{Device, Recording}

  import Phoenix.View

  setup %{conn: conn} do
    device = %Device{
      id: "1",
      name: "Camera 1",
      description: "Lobby",
      url: "rtsp://localhost/camera_1"
    }

    {:ok, %{conn: conn, device: device}}
  end

  test "renders index.html", %{conn: conn, device: device} do
    page = %Scrivener.Page{total_pages: 1, page_number: 1}

    recordings = [
      %Recording{
        id: "1",
        file: "File 1",
        started_at: DateTime.utc_now(),
        ended_at: DateTime.utc_now() |> DateTime.add(10 * 60, :second),
        device: device,
        device_id: device.id
      },
      %Recording{
        id: "2",
        file: "File 2",
        started_at: DateTime.utc_now(),
        ended_at: DateTime.utc_now() |> DateTime.add(10 * 60, :second),
        device: device,
        device_id: device.id
      }
    ]

    content =
      render_to_string(RecordingView, "index.html",
        conn: conn,
        device: device,
        recordings: recordings,
        page: page
      )

    for recording <- recordings do
      assert String.contains?(content, recording.file)
    end
  end

  test "renders show.html", %{conn: conn, device: device} do
    recording = %Recording{
      id: "1",
      file: "File 1",
      started_at: DateTime.utc_now(),
      ended_at: DateTime.utc_now() |> DateTime.add(10 * 60, :second),
      device: device,
      device_id: device.id
    }

    content =
      render_to_string(RecordingView, "show.html",
        conn: conn,
        device: device,
        recording: recording
      )

    assert String.contains?(content, recording.file)
  end

  test "refresh link", %{conn: conn, device: device} do
    assert RecordingView.refresh_link(conn, device) =~ "refresh"
  end

  test "device link", %{conn: conn, device: device} do
    assert RecordingView.device_link(conn, device) =~ device.name
  end
end
