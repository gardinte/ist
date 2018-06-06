defmodule Ist.Trail do
  def insert(struct_or_changeset, opts \\ []) do
    struct_or_changeset
    |> PaperTrail.insert(opts)
    |> extract_model()
  end

  def update(changeset, opts \\ []) do
    changeset
    |> PaperTrail.update(opts)
    |> extract_model()
  end

  def delete(struct_or_changeset, opts \\ []) do
    struct_or_changeset
    |> PaperTrail.delete(opts)
    |> extract_model()
  end

  defp extract_model({:ok, %{model: model}}), do: {:ok, model}
  defp extract_model(error), do: error
end
