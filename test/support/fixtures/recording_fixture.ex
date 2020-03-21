defmodule Ist.Support.Fixtures.RecordingFixture do
  alias Ist.Accounts.Session
  alias Ist.Recorder

  defmacro __using__(_opts) do
    quote do
      @recording_attrs %{
        file: "some file",
        started_at: DateTime.utc_now(),
        ended_at: DateTime.utc_now() |> DateTime.add(10 * 60, :second)
      }

      def fixture(:recording, attributes, %{account: account} = session) when is_map(session) do
        {:ok, device, _} = fixture(:device, %{})

        create_recording(session, device, attributes)
      end

      def fixture(:recording, attributes, _) do
        account = fixture(:seed_account)
        session = %Session{account: account}

        fixture(:recording, attributes, session)
      end

      defp create_recording(session, device, attributes) do
        attributes =
          attributes
          |> Enum.into(@recording_attrs)
          |> Map.put(:device_id, device.id)

        {:ok, recording} = Recorder.create_recording(session, attributes)

        {:ok, %{recording | device: device}, session.account}
      end
    end
  end
end
