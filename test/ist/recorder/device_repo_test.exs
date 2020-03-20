defmodule Ist.Recorder.DeviceRepoTest do
  use Ist.DataCase

  describe "device" do
    alias Ist.Recorder.Device

    @valid_attrs %{
      name: "some name",
      descriptor: "some description",
      url: "rtsp://localhost/device"
    }

    test "converts unique constraint on name to error" do
      {:ok, device, account} = fixture(:device, @valid_attrs)
      attrs = Map.put(@valid_attrs, :name, device.name)
      changeset = Device.changeset(account, %Device{}, attrs)
      prefix = Ist.Accounts.prefix(account)
      {:error, changeset} = Repo.insert(changeset, prefix: prefix)

      expected = {
        "has already been taken",
        [validation: :unsafe_unique, fields: [:name]]
      }

      assert expected == changeset.errors[:name]
    end

    test "converts unique constraint on uuid to error" do
      {:ok, device, account} = fixture(:device, @valid_attrs)
      attrs = Map.put(@valid_attrs, :uuid, device.uuid)
      changeset = Device.changeset(account, %Device{}, attrs)
      prefix = Ist.Accounts.prefix(account)
      {:error, changeset} = Repo.insert(changeset, prefix: prefix)

      expected = {
        "has already been taken",
        [validation: :unsafe_unique, fields: [:uuid]]
      }

      assert expected == changeset.errors[:uuid]
    end
  end
end
