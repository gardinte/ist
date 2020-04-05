defmodule Ist.PubSub.ProcessorWorker do
  require Logger

  alias Ist.Accounts
  alias Ist.Accounts.Session
  alias Ist.Recorder
  alias Ist.Recorder.{Device, Recording}
  alias Ist.PubSub.Notifier

  def process(%{"object" => object, "metadata" => %{"reference" => reference} = metadata}) do
    session = build_session(reference)
    device = get_device(session, reference)

    Recorder.create_recording(session, %{
      uuid: reference["recordingUuid"],
      file: object["name"],
      content_type: object["contentType"],
      size: object["size"],
      generation: object["generation"],
      started_at: metadata["startedAt"],
      ended_at: metadata["endedAt"],
      device_id: device.id
    })
  end

  def process(%{"event" => "created", "metadata" => %{"reference" => reference} = metadata}) do
    session = build_session(reference)
    device = get_device(session, reference)

    notify(session, device, metadata)

    {:ok, Recorder.update_device_status!(session, device, "recording")}
  end

  def process(%{"error" => %{"info" => info}, "reference" => reference}) do
    session = build_session(reference)
    device = get_device(session, reference)
    wait_time = Application.get_env(:ist, :wait_time_on_error, 30)

    Logger.error("Error message received")
    Logger.error(inspect(reference))
    Logger.error(inspect(info))

    device = Recorder.update_device_status!(session, device, "failing")

    # TODO: implement incremental back off or similar
    wait_time |> :timer.seconds() |> round() |> :timer.sleep()

    notify(session, device, reference)
  end

  def process(data) do
    message = "Unknown message"

    Logger.warn(message)
    Logger.warn(inspect(data))

    {:error, message}
  end

  defp build_session(%{"accountId" => account_id, "userId" => user_id}) do
    account = Accounts.get_account!(account_id)
    user = Accounts.get_user!(account, user_id)

    %Session{account: account, user: user}
  end

  defp get_device(%Session{account: account}, %{"deviceUuid" => device_uuid}) do
    Recorder.get_device_by_uuid!(account, device_uuid)
  end

  defp notify(%Session{} = session, %Device{} = device) do
    Notifier.notify(session, device)

    {:ok, device}
  end

  defp notify(%Session{} = session, %Device{} = device, %{"recordingUuid" => recordingUuid}) do
    Notifier.notify(session, device, recordingUuid)

    {:ok, device}
  end

  defp notify(%Session{account: account} = session, %Device{url: url} = device, %{
         "input" => url,
         "reference" => reference
       }) do
    case Recorder.get_recording(account, device, reference["recordingUuid"]) do
      %Recording{} ->
        {:ok, device}

      nil ->
        notify(session, device)
    end
  end

  defp notify(_session, device, _metadata), do: {:ok, device}
end
