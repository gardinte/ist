defmodule Ist.Accounts.AccountTest do
  use Ist.DataCase, async: true

  describe "account" do
    alias Ist.Accounts.Account

    @valid_attrs %{name: "some name", db_prefix: "db_prefix"}
    @invalid_attrs %{name: nil, db_prefix: "db prefix"}

    test "create_changeset with valid attributes" do
      changeset = Account.create_changeset(%Account{}, @valid_attrs)

      assert changeset.valid?
    end

    test "create_changeset with invalid attributes" do
      changeset = Account.create_changeset(%Account{}, @invalid_attrs)

      refute changeset.valid?
    end

    test "create_changeset does not accept long attributes" do
      attrs =
        @valid_attrs
        |> Map.put(:name, String.duplicate("a", 256))
        |> Map.put(:db_prefix, String.duplicate("a", 62))

      changeset = Account.create_changeset(%Account{}, attrs)

      assert "should be at most 255 character(s)" in errors_on(changeset).name
      assert "should be at most 61 character(s)" in errors_on(changeset).db_prefix
    end

    test "create_changeset check basic db prefix format" do
      attrs = Map.put(@valid_attrs, :db_prefix, "%")
      changeset = Account.create_changeset(%Account{}, attrs)

      assert "has invalid format" in errors_on(changeset).db_prefix
    end

    test "changeset ignores db_prefix" do
      changeset = Account.changeset(%Account{}, @valid_attrs)

      assert "can't be blank" in errors_on(changeset).db_prefix
    end
  end
end
