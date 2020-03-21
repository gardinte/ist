defmodule Ist.Recorder.Recording do
  use Ecto.Schema

  import Ecto.Changeset
  import Ist.Accounts.Account, only: [prefix: 1]

  alias Ist.Recorder.{Device, Recording}
  alias Ist.Accounts.Account

  schema "recordings" do
    field :file, :string
    field :started_at, :utc_datetime
    field :ended_at, :utc_datetime

    belongs_to :device, Device

    timestamps()
  end

  @doc false
  def changeset(%Account{} = account, %Recording{} = recording, attrs) do
    recording
    |> put_prefix(account)
    |> cast(attrs, [:file, :started_at, :ended_at, :device_id])
    |> validate_required([:file, :started_at, :ended_at, :device_id])
    |> validate_length(:file, max: 255)
    |> assoc_constraint(:device)
  end

  defp put_prefix(%Recording{__meta__: %{prefix: nil}} = recording, %Account{} = account) do
    meta = recording.__meta__ |> Map.put(:prefix, prefix(account))

    Map.put(recording, :__meta__, meta)
  end

  defp put_prefix(%Recording{} = recording, _account), do: recording
end
