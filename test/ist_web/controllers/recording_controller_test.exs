defmodule IstWeb.RecordingControllerTest do
  use IstWeb.ConnCase
  use Ist.Support.LoginHelper

  import Ist.Support.FixtureHelper

  describe "unauthorized access" do
    test "requires user authentication on all actions", %{conn: conn} do
      Enum.each(
        [
          get(conn, Routes.device_recording_path(conn, :index, "123")),
          get(conn, Routes.device_recording_path(conn, :show, "123", "123")),
          delete(conn, Routes.device_recording_path(conn, :delete, "123", "123"))
        ],
        fn conn ->
          assert html_response(conn, 302)
          assert conn.halted
        end
      )
    end
  end

  describe "index" do
    setup [:create_recording]

    @tag login_as: "test@user.com"
    test "lists all recordings", %{conn: conn, device: device, recording: recording} do
      conn = get(conn, Routes.device_recording_path(conn, :index, device))
      response = html_response(conn, 200)

      assert response =~ "Recordings"
      assert response =~ recording.file
    end
  end

  describe "empty index" do
    @tag login_as: "test@user.com"
    test "lists no recordings", %{conn: conn} do
      {:ok, device, _account} = fixture(:device)
      conn = get(conn, Routes.device_recording_path(conn, :index, device))

      assert html_response(conn, 200) =~ "there is no recordings"
    end
  end

  describe "show" do
    setup [:create_recording]

    @tag login_as: "test@user.com"
    test "show recording", %{conn: conn, device: device, recording: recording} do
      conn = get(conn, Routes.device_recording_path(conn, :show, device, recording))
      response = html_response(conn, 200)

      assert response =~ recording.file
    end
  end

  describe "delete recording" do
    setup [:create_recording]

    @tag login_as: "test@user.com"
    test "deletes chosen recording", %{conn: conn, device: device, recording: recording} do
      conn = delete(conn, Routes.device_recording_path(conn, :delete, device, recording))

      assert redirected_to(conn) == Routes.device_recording_path(conn, :index, device)
    end
  end

  defp create_recording(_) do
    {:ok, recording, _} = fixture(:recording)

    {:ok, device: recording.device, recording: recording}
  end
end
