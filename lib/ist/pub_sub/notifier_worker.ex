defmodule Ist.PubSub.NotifierWorker do
  alias Ist.Accounts.{Account, Session}
  alias Ist.Recorder.Device

  def notify(%Session{account: account, user: user}, %Device{} = device, recordingUuid) do
    implementation = Application.get_env(:ist, :notifier)
    bucket = Application.fetch_env!(:ist, :bucket)

    implementation.publish(%{
      input: device.url,
      bucket: bucket,
      metadata: %{
        reference: %{
          accountId: account.id,
          userId: user.id,
          deviceUuid: device.uuid,
          recordingUuid: recordingUuid
        },
        path: path(account, device)
      }
    })
  end

  defp path(account, device) do
    "#{Account.prefix(account)}/recordings/#{device.uuid}"
  end
end
