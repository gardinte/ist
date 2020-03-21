defmodule Ist.Recorder.RecordingTest do
  use Ist.DataCase, async: true

  describe "recording" do
    alias Ist.Recorder.Recording

    @valid_attrs %{
      file: "some file",
      started_at: DateTime.utc_now(),
      ended_at: DateTime.utc_now() |> DateTime.add(10 * 60, :second),
      device_id: "1"
    }
    @invalid_attrs %{file: nil, started_at: nil, ended_at: nil}

    test "changeset with valid attributes" do
      changeset = test_account() |> Recording.changeset(%Recording{}, @valid_attrs)

      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = test_account() |> Recording.changeset(%Recording{}, @invalid_attrs)

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).file
      assert "can't be blank" in errors_on(changeset).started_at
      assert "can't be blank" in errors_on(changeset).ended_at
      assert "can't be blank" in errors_on(changeset).device_id
    end

    test "changeset does not accept long attributes" do
      attrs =
        @valid_attrs
        |> Map.put(:file, String.duplicate("a", 256))

      changeset = test_account() |> Recording.changeset(%Recording{}, attrs)

      assert "should be at most 255 character(s)" in errors_on(changeset).file
    end
  end

  defp test_account do
    %Ist.Accounts.Account{db_prefix: "test_account"}
  end
end
