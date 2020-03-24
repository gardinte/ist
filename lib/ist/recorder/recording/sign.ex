defmodule Ist.Recorder.Recording.Sign do
  def signed_url(recording, opts \\ []) do
    {:ok, url} =
      :ist
      |> Application.fetch_env!(:bucket)
      |> Guss.new(recording.file, opts)
      |> Guss.sign()

    url
  end
end
