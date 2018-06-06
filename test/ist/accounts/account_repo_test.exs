defmodule Ist.Accounts.AccountRepoTest do
  use Ist.DataCase

  alias Ecto.Adapters.SQL
  alias Ist.Repo

  describe "account" do
    alias Ist.Accounts.Account

    @valid_attrs %{name: "some name", db_prefix: "db_prefix"}

    test "converts unique constraint on db prefix to error" do
      account = fixture(:seed_account)
      attrs = Map.put(@valid_attrs, :db_prefix, account.db_prefix)
      changeset = Account.create_changeset(%Account{}, attrs)

      assert {:error, changeset} = Repo.insert(changeset)
      assert "has already been taken" in errors_on(changeset).db_prefix
    end

    test "after create creates schema and migrates" do
      changeset = Account.create_changeset(%Account{}, @valid_attrs)

      refute schema_exists?(@valid_attrs.db_prefix)

      {:ok, _} =
        changeset
        |> Repo.insert()
        |> Account.after_create()

      assert schema_exists?(@valid_attrs.db_prefix)
      assert schema_migrated?(@valid_attrs.db_prefix)
    end

    test "after delete drops schema" do
      account = fixture(:account, @valid_attrs, create_schema: true)

      assert schema_exists?(@valid_attrs.db_prefix)

      account
      |> Repo.delete()
      |> Account.after_delete()

      refute schema_exists?(@valid_attrs.db_prefix)
    end
  end

  defp schema_exists?(prefix) do
    query =
      "SELECT schema_name FROM information_schema.schemata WHERE schema_name = 't_#{prefix}';"

    {:ok, %{num_rows: rows}} = SQL.query(Repo, query)

    rows == 1
  end

  defp schema_migrated?(prefix) do
    query = "SELECT COUNT(version) FROM t_#{prefix}.schema_migrations;"

    {:ok, %{rows: [[count]]}} = SQL.query(Repo, query)

    count > 0
  end
end
