defmodule Ist.Repo.Migrations.CreateDevices do
  use Ist, :migration

  def change do
    if prefix = prefix() do
      do_change(prefix)
    else
      for prefix <- account_prefixes(), do: do_change(prefix)
    end
  end

  defp do_change(prefix) do
    create table(:devices, prefix: prefix) do
      add :uuid, :string, null: false
      add :name, :string, null: false
      add :description, :text
      add :status, :string, null: false
      add :url, :text, null: false
      add :lock_version, :integer, default: 1, null: false

      timestamps type: :utc_datetime
    end

    create unique_index(:devices, [:uuid], prefix: prefix)
    create unique_index(:devices, [:name], prefix: prefix)
    create unique_index(:devices, [:status], prefix: prefix)
  end
end
