defmodule Ist.PubSub.Processor do
  @behaviour Psb.Processor

  alias Ist.PubSub.{Worker, WorkerSupervisor}

  @impl true
  def process(data) do
    Task.Supervisor.start_child(WorkerSupervisor, Worker, :process, [data], restart: :transient)

    {:ok, data}
  end
end
