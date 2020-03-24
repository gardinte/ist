defmodule Ist.PubSub.Worker do
  require Logger

  alias Ist.Accounts
  alias Ist.Accounts.Session
  alias Ist.Recorder

  def process(%{"object" => object, "metadata" => %{"reference" => reference} = metadata}) do
    account = Accounts.get_account!(reference["accountId"])
    user = Accounts.get_user!(account, reference["userId"])
    device = Recorder.get_device_by_uuid!(account, reference["deviceUuid"])

    Recorder.create_recording(%Session{account: account, user: user}, %{
      file: object["name"],
      content_type: object["contentType"],
      size: object["size"],
      generation: object["generation"],
      started_at: metadata["startedAt"],
      ended_at: metadata["endedAt"],
      device_id: device.id
    })
  end

  def process(data) do
    message = "Unknown message"

    Logger.warn(message)
    Logger.warn(inspect(data))

    {:error, message}
  end
end
