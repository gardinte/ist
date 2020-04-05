defmodule Ist.PubSub.NotifierTest do
  use Ist.DataCase

  describe "notifier" do
    alias Ist.Accounts.Session
    alias Ist.PubSub.Notifier

    test "notify/2" do
      {:ok, device, account} = fixture(:device)
      {:ok, user, _account} = fixture(:user, %{account: account})
      session = %Session{account: account, user: user}
      url = device.url
      uuid = device.uuid

      Application.put_env(:ist, :test_process, self())

      assert {:ok, _message} = Notifier.notify(session, device)
      assert_receive %{input: ^url, metadata: %{reference: %{deviceUuid: ^uuid}}}, 1_000
    end

    test "notify/3 with UUID" do
      {:ok, device, account} = fixture(:device)
      {:ok, user, _account} = fixture(:user, %{account: account})
      session = %Session{account: account, user: user}
      url = device.url
      deviceUuid = device.uuid
      recordingUuid = Ecto.UUID.generate()

      Application.put_env(:ist, :test_process, self())

      assert {:ok, _message} = Notifier.notify(session, device, recordingUuid)

      assert_receive %{
                       input: ^url,
                       metadata: %{
                         reference: %{deviceUuid: ^deviceUuid, recordingUuid: ^recordingUuid}
                       }
                     },
                     1_000
    end
  end
end
