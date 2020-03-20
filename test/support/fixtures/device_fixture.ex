defmodule Ist.Support.Fixtures.DeviceFixture do
  alias Ist.Accounts.Session
  alias Ist.Recorder

  defmacro __using__(_opts) do
    quote do
      @device_attrs %{
        name: "some name",
        description: "some description",
        url: "rtsp://localhost/device"
      }

      def fixture(:device, attributes, %{account: account} = session) when is_map(session) do
        attributes = Enum.into(attributes, @device_attrs)
        {:ok, device} = Recorder.create_device(session, attributes)

        {:ok, device, account}
      end

      def fixture(:device, attributes, _) do
        account = fixture(:seed_account)
        session = %Session{account: account}

        fixture(:device, attributes, session)
      end
    end
  end
end
