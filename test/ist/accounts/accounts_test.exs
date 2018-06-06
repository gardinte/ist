defmodule Ist.AccountsTest do
  use Ist.DataCase

  alias Ist.Accounts

  describe "accounts" do
    alias Ist.Accounts.Account

    @valid_attrs %{db_prefix: "db_prefix", name: "some name"}
    @update_attrs %{db_prefix: "updated_db_prefix", name: "some updated name"}
    @invalid_attrs %{db_prefix: "db prefix", name: nil}

    test "list_accounts/0 returns all accounts" do
      account = fixture(:seed_account)

      assert Accounts.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = fixture(:seed_account)

      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account without schema" do
      assert {:ok, %Account{} = account} =
               Accounts.create_account(@valid_attrs, create_schema: false)

      assert account.db_prefix == "db_prefix"
      assert account.name == "some name"
      refute schema_exists?(account.db_prefix)
    end

    test "create_account/1 with valid data creates a account with schema" do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
      assert account.db_prefix == "db_prefix"
      assert account.name == "some name"
      assert schema_exists?(account.db_prefix)
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = fixture(:seed_account)

      assert {:ok, account} = Accounts.update_account(account, @update_attrs)
      assert %Account{} = account
      # Ignored on update
      assert account.db_prefix == "test_account"
      assert account.name == "some updated name"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = fixture(:seed_account)

      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = fixture(:account, @valid_attrs)

      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = fixture(:seed_account)

      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end

  alias Ist.Accounts.Session

  describe "users" do
    alias Ist.Accounts.User

    @valid_attrs %{
      email: "some@email.com",
      lastname: "some lastname",
      name: "some name",
      password: "123456",
      password_confirmation: "123456"
    }
    @update_attrs %{
      email: "new@email.com",
      lastname: "some updated lastname",
      name: "some updated name"
    }
    @invalid_attrs %{email: "wrong@email", lastname: nil, name: nil, password: "123"}

    test "list_users/2 returns all users on the specified account" do
      {:ok, user, account} = fixture(:user)

      assert Accounts.list_users(account, %{}).entries == [user]
    end

    test "list_users/2 returns empty list for empty account" do
      account = fixture(:account, %{db_prefix: "accounts_user_test"})

      # Unlisted user
      fixture(:user)

      assert Accounts.list_users(account, %{}).entries == []
    end

    test "get_user!/2 returns the user with given account and id" do
      {:ok, user, account} = fixture(:user)

      assert Accounts.get_user!(account, user.id) == user
    end

    test "get_user!/2 returns no result when user account and id mismatch" do
      account = fixture(:account, %{db_prefix: "accounts_user_test"})
      {:ok, user, _} = fixture(:user)

      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!(account, user.id)
      end
    end

    test "get_user/1 returns user when email option is correct" do
      {:ok, user, _} = fixture(:user)

      assert Accounts.get_user(email: user.email) == user
    end

    test "get_user/1 returns nil when email option is incorrect" do
      refute Accounts.get_user(email: "no@user.com")
    end

    test "get_user/1 returns user when token option is correct" do
      {:ok, user, _} = fixture(:user)

      user =
        user
        |> User.password_reset_token_changeset()
        |> Repo.update!()

      assert Accounts.get_user(token: user.password_reset_token) == user
    end

    test "get_user/1 returns nil when token option is incorrect" do
      refute Accounts.get_user(token: "wrong-token")
    end

    test "create_user/2 with valid data creates a user" do
      account = fixture(:seed_account)
      session = %Session{account: account}

      assert {:ok, %User{} = user} = Accounts.create_user(session, @valid_attrs)
      assert user.email == "some@email.com"
      assert user.lastname == "some lastname"
      assert user.name == "some name"
    end

    test "create_user/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(%Session{}, @invalid_attrs)
    end

    test "update_user/3 with valid data updates the user" do
      {:ok, user, account} = fixture(:user, @valid_attrs)
      session = %Session{account: account, user: user}

      assert {:ok, user} = Accounts.update_user(session, user, @update_attrs)
      assert %User{} = user
      assert user.email == "new@email.com"
      assert user.lastname == "some updated lastname"
      assert user.name == "some updated name"
    end

    test "update_user/3 with invalid data returns error changeset" do
      {:ok, user, account} = fixture(:user)
      session = %Session{account: account, user: user}

      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(session, user, @invalid_attrs)
      assert user == Accounts.get_user!(account, user.id)
    end

    test "update_user_password/2 with valid data updates the user" do
      attrs = %{password: "newpass", password_confirmation: "newpass"}
      {:ok, user, _} = fixture(:user, @valid_attrs)

      assert {:ok, user} = Accounts.update_user_password(user, attrs)
      assert %User{} = user
      assert Comeonin.Argon2.checkpw(attrs.password, user.password_hash)
    end

    test "update_user_password/2 with invalid data returns error changeset" do
      attrs = %{password: "newpass", password_confirmation: "wrong"}
      {:ok, user, account} = fixture(:user)

      assert {:error, %Ecto.Changeset{}} = Accounts.update_user_password(user, attrs)
      assert user == Accounts.get_user!(account, user.id)
    end

    test "delete_user/1 deletes the user" do
      {:ok, user, account} = fixture(:user)
      session = %Session{account: account, user: user}

      assert {:ok, %User{}} = Accounts.delete_user(session, user)

      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!(account, user.id)
      end
    end

    test "change_user/1 returns a user changeset" do
      {:ok, user, _} = fixture(:user)

      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "change_user_password/1 returns a user changeset" do
      {:ok, user, _} = fixture(:user)

      assert %Ecto.Changeset{} = Accounts.change_user_password(user)
    end
  end

  describe "session" do
    alias Ist.Accounts.Session

    test "get_current_session/2 returns the session with given account and user id" do
      {:ok, user, account} = fixture(:user)
      %Session{} = session = Accounts.get_current_session(account.id, user.id)

      assert user == session.user
      assert account == session.account
    end
  end

  describe "auth" do
    test "authenticate_by_email_and_password/2 returns :ok with valid credentials" do
      {:ok, user, _} = fixture(:user, @valid_attrs)
      email = @valid_attrs.email
      password = @valid_attrs.password

      {:ok, auth_user} = Accounts.authenticate_by_email_and_password(email, password)

      assert auth_user == user
    end

    test "authenticate_by_email_and_password/2 returns :error with invalid credentials" do
      email = @valid_attrs.email
      password = "wrong"

      # Create user just to be sure
      fixture(:user, @valid_attrs)

      assert {:error, :unauthorized} ==
               Accounts.authenticate_by_email_and_password(email, password)
    end

    test "authenticate_by_email_and_password/2 returns :error with invalid email" do
      email = "invalid@email.com"
      password = @valid_attrs.password

      assert {:error, :unauthorized} ==
               Accounts.authenticate_by_email_and_password(email, password)
    end
  end

  describe "password" do
    alias Ist.Notifications.Email
    use Bamboo.Test

    test "reset" do
      {:ok, user, _} = fixture(:user)
      {:ok, user} = Accounts.password_reset(user)

      assert_delivered_email(Email.password_reset(user))
    end
  end

  defp schema_exists?(prefix) do
    query =
      "SELECT schema_name FROM information_schema.schemata WHERE schema_name = 't_#{prefix}';"

    {:ok, %{num_rows: rows}} = Ecto.Adapters.SQL.query(Repo, query)

    rows == 1
  end
end
