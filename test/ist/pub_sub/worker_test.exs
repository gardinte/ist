defmodule Ist.PubSub.WorkerRepoTest do
  use Ist.DataCase

  import ExUnit.CaptureLog

  describe "worker" do
    alias Ist.PubSub.Worker
    alias Ist.Recorder.Recording

    @object %{
      "name" => "some file",
      "contentType" => "video/mp4",
      "size" => 60000,
      "generation" => 1
    }

    test "process new object message" do
      {:ok, device, account} = fixture(:device)
      {:ok, user, _account} = fixture(:user, %{account: account})

      metadata = %{
        "reference" => %{
          "accountId" => account.id,
          "userId" => user.id,
          "deviceUuid" => device.uuid
        },
        "startedAt" => DateTime.utc_now() |> DateTime.to_iso8601(),
        "endedAt" => DateTime.utc_now() |> DateTime.add(10 * 60, :second) |> DateTime.to_iso8601()
      }

      assert {:ok, %Recording{} = recording} =
               Worker.process(%{"object" => @object, "metadata" => metadata})

      assert recording.device_id == device.id
    end

    test "process unknown message" do
      fun = fn ->
        assert {:error, message} = Worker.process(%{})
      end

      assert capture_log(fun) =~ "Unknown message"
    end
  end
end
