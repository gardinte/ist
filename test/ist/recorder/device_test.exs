defmodule Ist.Recorder.DeviceTest do
  use Ist.DataCase, async: true

  describe "device" do
    alias Ist.Recorder.Device

    @valid_attrs %{
      name: "some name",
      descriptor: "some description",
      status: "unknown",
      url: "rtsp://localhost/device"
    }
    @invalid_attrs %{logo: nil, name: nil, description: nil, status: nil, url: nil}

    test "changeset with valid attributes" do
      changeset = test_account() |> Device.changeset(%Device{}, @valid_attrs)

      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = test_account() |> Device.changeset(%Device{}, @invalid_attrs)

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).name
      assert "can't be blank" in errors_on(changeset).url
    end

    test "changeset does not accept long attributes" do
      attrs =
        @valid_attrs
        |> Map.put(:name, String.duplicate("a", 256))
        |> Map.put(:url, String.duplicate("a", 2048))

      changeset = test_account() |> Device.changeset(%Device{}, attrs)

      assert "should be at most 255 character(s)" in errors_on(changeset).name
      assert "should be at most 2047 character(s)" in errors_on(changeset).url
    end

    test "changeset check basic URL format" do
      attrs = Map.put(@valid_attrs, :url, "wrong://host")
      changeset = test_account() |> Device.changeset(%Device{}, attrs)

      assert "has invalid format" in errors_on(changeset).url
    end
  end

  defp test_account do
    %Ist.Accounts.Account{db_prefix: "test_account"}
  end
end
