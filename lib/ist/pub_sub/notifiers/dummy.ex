defmodule Ist.PubSub.Notifiers.Dummy do
  @behaviour Ist.PubSub.Notifier

  @impl true
  def publish(%{} = message) do
    process = Application.get_env(:ist, :test_process)

    do_publish(process, message)
  end

  defp do_publish(nil, message), do: {:ok, message}
  defp do_publish(process, message), do: {:ok, send(process, message)}
end
