defmodule Ist.RecorderTest do
  use Ist.DataCase

  alias Ist.Recorder
  alias Ist.Accounts.Session

  describe "devices" do
    alias Ist.Recorder.Device

    @valid_attrs %{
      description: "some description",
      name: "some name",
      url: "rtsp://localhost/device"
    }
    @update_attrs %{
      description: "some updated description",
      name: "some updated name",
      url: "rtsp://localhost/updated_device"
    }
    @invalid_attrs %{description: nil, name: nil, url: nil}

    test "list_devices/2 returns all devices" do
      {:ok, device, account} = fixture(:device)

      assert Recorder.list_devices(account, %{}).entries == [device]
    end

    test "get_device!/2 returns the device with given id" do
      {:ok, device, account} = fixture(:device)

      assert Recorder.get_device!(account, device.id) == device
    end

    test "create_device/2 with valid data creates a device" do
      account = fixture(:seed_account)
      session = %Session{account: account}

      assert {:ok, %Device{} = device} = Recorder.create_device(session, @valid_attrs)
      assert device.description == "some description"
      assert device.name == "some name"
      assert device.url == "rtsp://localhost/device"
    end

    test "create_device/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recorder.create_device(%Session{}, @invalid_attrs)
    end

    test "update_device/3 with valid data updates the device" do
      {:ok, device, account} = fixture(:device)
      session = %Session{account: account}

      assert {:ok, device} = Recorder.update_device(session, device, @update_attrs)
      assert %Device{} = device
      assert device.description == "some updated description"
      assert device.name == "some updated name"
      assert device.url == "rtsp://localhost/updated_device"
    end

    test "update_device/3 with invalid data returns error changeset" do
      {:ok, device, account} = fixture(:device)
      session = %Session{account: account}

      assert {:error, %Ecto.Changeset{}} = Recorder.update_device(session, device, @invalid_attrs)
      assert device == Recorder.get_device!(account, device.id)
    end

    test "delete_device/2 deletes the device" do
      {:ok, device, account} = fixture(:device)
      session = %Session{account: account}

      assert {:ok, %Device{}} = Recorder.delete_device(session, device)
      assert_raise Ecto.NoResultsError, fn -> Recorder.get_device!(account, device.id) end
    end

    test "change_device/2 returns a device changeset" do
      {:ok, device, account} = fixture(:device)

      assert %Ecto.Changeset{} = Recorder.change_device(account, device)
    end
  end
end
