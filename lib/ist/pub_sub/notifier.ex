defmodule Ist.PubSub.Notifier do
  @callback publish(map()) :: {:ok, map()} | {:error, String.t()}

  alias Ist.PubSub.{NotifierWorker, WorkerSupervisor}

  def notify(session, device, recordingUuid \\ Ecto.UUID.generate()) do
    Task.Supervisor.start_child(
      WorkerSupervisor,
      NotifierWorker,
      :notify,
      [session, device, recordingUuid],
      restart: :transient
    )

    {:ok, recordingUuid}
  end
end
