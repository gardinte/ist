defmodule IstWeb.DeviceControllerTest do
  use IstWeb.ConnCase
  use Ist.Support.LoginHelper

  import Ist.Support.FixtureHelper

  @create_attrs %{
    name: "some name",
    description: "some description",
    status: "unknown",
    url: "rtsp://localhost/device"
  }
  @update_attrs %{
    name: "some updated name",
    description: "some updated description",
    status: "starting",
    url: "rtsp://localhost/updated_device"
  }
  @invalid_attrs %{name: nil, description: nil, status: nil, url: nil}

  describe "unauthorized access" do
    test "requires user authentication on all actions", %{conn: conn} do
      Enum.each(
        [
          get(conn, Routes.device_path(conn, :index)),
          get(conn, Routes.device_path(conn, :new)),
          post(conn, Routes.device_path(conn, :create, %{})),
          get(conn, Routes.device_path(conn, :show, "123")),
          get(conn, Routes.device_path(conn, :edit, "123")),
          put(conn, Routes.device_path(conn, :update, "123", %{})),
          delete(conn, Routes.device_path(conn, :delete, "123"))
        ],
        fn conn ->
          assert html_response(conn, 302)
          assert conn.halted
        end
      )
    end
  end

  describe "index" do
    setup [:create_device]

    @tag login_as: "test@user.com"
    test "lists all devices", %{conn: conn, device: device} do
      conn = get(conn, Routes.device_path(conn, :index))
      response = html_response(conn, 200)

      assert response =~ "Devices"
      assert response =~ device.name
    end
  end

  describe "empty index" do
    @tag login_as: "test@user.com"
    test "lists no devices", %{conn: conn} do
      conn = get(conn, Routes.device_path(conn, :index))

      assert html_response(conn, 200) =~ "you have no devices"
    end
  end

  describe "new device" do
    @tag login_as: "test@user.com"
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.device_path(conn, :new))

      assert html_response(conn, 200) =~ "New device"
    end
  end

  describe "create device" do
    @tag login_as: "test@user.com"
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.device_path(conn, :create), device: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.device_path(conn, :show, id)
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.device_path(conn, :create), device: @invalid_attrs

      assert html_response(conn, 200) =~ "New device"
    end
  end

  describe "show" do
    setup [:create_device]

    @tag login_as: "test@device.com"
    test "show device", %{conn: conn, device: device} do
      conn = get(conn, Routes.device_path(conn, :show, device))
      response = html_response(conn, 200)

      assert response =~ device.name
    end
  end

  describe "edit device" do
    setup [:create_device]

    @tag login_as: "test@user.com"
    test "renders form for editing chosen device", %{conn: conn, device: device} do
      conn = get(conn, Routes.device_path(conn, :edit, device))

      assert html_response(conn, 200) =~ "Edit device"
    end
  end

  describe "update device" do
    setup [:create_device]

    @tag login_as: "test@user.com"
    test "redirects when data is valid", %{conn: conn, device: device} do
      conn = put conn, Routes.device_path(conn, :update, device), device: @update_attrs

      assert redirected_to(conn) == Routes.device_path(conn, :show, device)
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn, device: device} do
      conn = put conn, Routes.device_path(conn, :update, device), device: @invalid_attrs

      assert html_response(conn, 200) =~ "Edit device"
    end
  end

  describe "delete device" do
    setup [:create_device]

    @tag login_as: "test@user.com"
    test "deletes chosen device", %{conn: conn, device: device} do
      conn = delete(conn, Routes.device_path(conn, :delete, device))

      assert redirected_to(conn) == Routes.device_path(conn, :index)
    end
  end

  defp create_device(_) do
    {:ok, device, _} = fixture(:device)

    {:ok, device: device}
  end
end
