defmodule Repo.Migrations.CreateVersions do
  use Ist, :migration

  def change do
    if prefix = prefix() do
      do_change(prefix)
    else
      for prefix <- account_prefixes(), do: do_change(prefix)

      # Add also to the public schema on "main" migration
      do_change("public")
    end
  end

  defp do_change(prefix) do
    create table(:versions, prefix: prefix) do
      add :event, :string, null: false, size: 10
      add :item_type, :string, null: false
      add :item_id, :bigint
      add :item_changes, :map, null: false
      add :originator_id, :bigint
      add :origin, :string, size: 50
      add :meta, :map

      add :inserted_at, :utc_datetime, null: false
    end

    create index(:versions, :originator_id, prefix: prefix)
    create index(:versions, [:item_id, :item_type], prefix: prefix)
  end
end
