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
      status: "unknown",
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
        content_type: "video/mp4",
        size: 60000,
        generation: 1,
        started_at: DateTime.utc_now(),
        ended_at: DateTime.utc_now() |> DateTime.add(10 * 60, :second),
        device: device,
        device_id: device.id
      },
      %Recording{
        id: "2",
        file: "File 2",
        content_type: "video/mp4",
        size: 70000,
        generation: 1,
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
      assert String.contains?(content, RecordingView.human_size(recording.size))
    end
  end

  test "renders show.html", %{conn: conn, device: device} do
    recording = %Recording{
      id: "1",
      file: "File 1",
      content_type: "video/mp4",
      size: 60000,
      generation: 1,
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

    assert String.contains?(content, device.name)
  end

  test "refresh link", %{conn: conn, device: device} do
    assert RecordingView.refresh_link(conn, device) =~ "refresh"
  end

  test "device link", %{conn: conn, device: device} do
    assert RecordingView.device_link(conn, device) =~ device.name
  end

  test "human size" do
    assert RecordingView.human_size(1024) == "1.0 KB"
    assert RecordingView.human_size(1024 * 1024) == "1.0 MB"
    assert RecordingView.human_size(14) == "14.0 B"
    assert RecordingView.human_size(691_423) == "675.22 KB"
  end
end
