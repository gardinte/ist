defmodule Ist.PubSub.Processor do
  @behaviour Psb.Processor

  alias Ist.PubSub.{ProcessorWorker, WorkerSupervisor}

  @impl true
  def process(data) do
    Task.Supervisor.start_child(WorkerSupervisor, ProcessorWorker, :process, [data],
      restart: :transient
    )

    {:ok, data}
  end
end
