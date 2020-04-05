defmodule Ist.Recorder.Recording do
  use Ecto.Schema

  import Ecto.Changeset
  import Ist.Accounts.Account, only: [prefix: 1]

  alias Ist.Recorder.{Device, Recording}
  alias Ist.Accounts.Account
  alias Ist.Repo

  schema "recordings" do
    field :uuid, :string
    field :file, :string
    field :content_type, :string
    field :size, :integer
    field :generation, :integer
    field :started_at, :utc_datetime
    field :ended_at, :utc_datetime

    belongs_to :device, Device

    timestamps type: :utc_datetime
  end

  @cast_attrs [
    :uuid,
    :file,
    :content_type,
    :size,
    :generation,
    :started_at,
    :ended_at,
    :device_id
  ]

  @doc false
  def changeset(%Account{} = account, %Recording{} = recording, attrs) do
    recording
    |> put_prefix(account)
    |> cast(attrs, @cast_attrs)
    |> validate_required(@cast_attrs)
    |> validate_length(:uuid, max: 255)
    |> validate_length(:file, max: 255)
    |> validate_length(:content_type, max: 255)
    |> unsafe_validate_unique(:uuid, Repo, prefix: prefix(account))
    |> unique_constraint(:uuid)
    |> assoc_constraint(:device)
  end

  defp put_prefix(%Recording{__meta__: %{prefix: nil}} = recording, %Account{} = account) do
    meta = recording.__meta__ |> Map.put(:prefix, prefix(account))

    Map.put(recording, :__meta__, meta)
  end

  defp put_prefix(%Recording{} = recording, _account), do: recording
end
