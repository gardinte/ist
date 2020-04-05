defmodule Ist.PubSub.ProcessorWorkerRepoTest do
  use Ist.DataCase

  import ExUnit.CaptureLog

  describe "worker" do
    alias Ist.PubSub.ProcessorWorker
    alias Ist.Recorder.{Device, Recording}

    @object %{
      "name" => "some file",
      "contentType" => "video/mp4",
      "size" => 60000,
      "generation" => 1
    }

    test "process new object message" do
      recordingUuid = Ecto.UUID.generate()
      {:ok, device, account} = fixture(:device)
      {:ok, user, _account} = fixture(:user, %{account: account})

      metadata = %{
        "reference" => %{
          "accountId" => account.id,
          "userId" => user.id,
          "deviceUuid" => device.uuid,
          "recordingUuid" => recordingUuid
        },
        "input" => device.url,
        "startedAt" => DateTime.utc_now() |> DateTime.to_iso8601(),
        "endedAt" => DateTime.utc_now() |> DateTime.add(10 * 60, :second) |> DateTime.to_iso8601()
      }

      assert {:ok, %Recording{} = recording} =
               ProcessorWorker.process(%{"object" => @object, "metadata" => metadata})

      assert recording.device_id == device.id
      assert recording.uuid == recordingUuid
    end

    test "process created event message" do
      {:ok, device, account} = fixture(:device)
      {:ok, user, _account} = fixture(:user, %{account: account})
      url = device.url
      deviceUuid = device.uuid

      Application.put_env(:ist, :test_process, self())

      metadata = %{
        "input" => device.url,
        "reference" => %{
          "accountId" => account.id,
          "userId" => user.id,
          "deviceUuid" => device.uuid,
          "recordingUuid" => Ecto.UUID.generate()
        }
      }

      refute device.status == "recording"

      assert {:ok, %Device{} = device} =
               ProcessorWorker.process(%{"event" => "created", "metadata" => metadata})

      assert_receive %{input: ^url, metadata: %{reference: %{deviceUuid: ^deviceUuid}}}, 1_000

      assert device.status == "recording"
    end

    test "process created event message on existing recording" do
      {:ok, recording, account} = fixture(:recording)
      {:ok, user, _account} = fixture(:user, %{account: account})
      device = recording.device
      url = device.url
      deviceUuid = device.uuid

      Application.put_env(:ist, :test_process, self())

      metadata = %{
        "input" => device.url,
        "reference" => %{
          "accountId" => account.id,
          "userId" => user.id,
          "deviceUuid" => device.uuid,
          "recordingUuid" => recording.uuid
        }
      }

      refute device.status == "recording"

      assert {:ok, %Device{} = device} =
               ProcessorWorker.process(%{"event" => "created", "metadata" => metadata})

      refute_received %{input: ^url, metadata: %{reference: %{deviceUuid: ^deviceUuid}}}
      assert device.status == "recording"
    end

    test "process error message" do
      {:ok, device, account} = fixture(:device)
      {:ok, user, _account} = fixture(:user, %{account: account})
      url = device.url
      deviceUuid = device.uuid
      recordingUuid = Ecto.UUID.generate()

      Application.put_env(:ist, :test_process, self())

      reference = %{
        "accountId" => account.id,
        "userId" => user.id,
        "deviceUuid" => device.uuid,
        "recordingUuid" => recordingUuid
      }

      refute device.status == "failing"

      fun = fn ->
        assert {:ok, %Device{}} =
                 ProcessorWorker.process(%{
                   "error" => %{"info" => "Test error"},
                   "reference" => reference
                 })
      end

      assert capture_log(fun) =~ inspect("Test error")

      assert_receive %{
                       input: ^url,
                       metadata: %{
                         reference: %{deviceUuid: ^deviceUuid, recordingUuid: ^recordingUuid}
                       }
                     },
                     1_000

      device = Ist.Recorder.get_device!(account, device.id)

      assert device.status == "failing"
    end

    test "process unknown message" do
      fun = fn ->
        assert {:error, message} = ProcessorWorker.process(%{})
      end

      assert capture_log(fun) =~ "Unknown message"
    end
  end
end
