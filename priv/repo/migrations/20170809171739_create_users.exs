defmodule Ist.Repo.Migrations.CreateUsers do
  use Ist, :migration

  def change do
    unless prefix() do
      create table(:users) do
        add :name, :string, null: false
        add :lastname, :string, null: false
        add :email, :string, null: false
        add :password_hash, :string, null: false
        add :password_reset_token, :string
        add :password_reset_sent_at, :utc_datetime
        add :lock_version, :integer, default: 1, null: false

        add :account_id, references(:accounts, on_delete: :delete_all), null: false

        timestamps()
      end

      create unique_index(:users, [:email])
      create unique_index(:users, [:password_reset_token])
      create index(:users, [:account_id])
    end
  end
end
