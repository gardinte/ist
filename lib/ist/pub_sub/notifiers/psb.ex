defmodule Ist.PubSub.Notifiers.Psb do
  @behaviour Ist.PubSub.Notifier

  @impl true
  def publish(%{} = message), do: Psb.publish(message)
end
