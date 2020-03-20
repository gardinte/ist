defmodule Ist.Repo.Migrations.CreateAccounts do
  use Ist, :migration

  def up do
    unless prefix() do
      create table(:accounts) do
        add :name, :string, null: false
        add :db_prefix, :string, null: false
        add :lock_version, :integer, default: 1, null: false

        timestamps()
      end

      create unique_index(:accounts, [:db_prefix])
    end
  end

  def down do
    unless prefix() do
      drop_all_schemas()
      drop table(:accounts)
    end
  end

  defp drop_all_schemas() do
    for prefix <- account_prefixes(), do: drop_schema(prefix)
  end

  defp drop_schema(prefix) do
    case Ist.Repo.__adapter__() do
      Ecto.Adapters.Postgres -> execute("DROP SCHEMA \"#{prefix}\" CASCADE")
    end
  end
end
