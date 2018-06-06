defmodule Ist.Accounts.UserTest do
  use Ist.DataCase, async: true

  describe "user" do
    alias Ist.Accounts.User

    @valid_attrs %{
      email: "some@email.com",
      lastname: "some lastname",
      name: "some name",
      password: "123456",
      password_confirmation: "123456"
    }
    @invalid_attrs %{
      email: "wrong@email",
      lastname: nil,
      name: nil,
      password: "123",
      account_id: nil
    }

    test "changeset with valid attributes" do
      changeset = User.changeset(%User{}, @valid_attrs)

      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = User.changeset(%User{}, @invalid_attrs)

      refute changeset.valid?
    end

    test "changeset does not accept short attributes" do
      attrs =
        @valid_attrs
        |> Map.put(:password, String.duplicate("a", 5))

      changeset = User.changeset(%User{}, attrs)

      assert "should be at least 6 character(s)" in errors_on(changeset).password
    end

    test "changeset does not accept long attributes" do
      attrs =
        @valid_attrs
        |> Map.put(:name, String.duplicate("a", 256))
        |> Map.put(:lastname, String.duplicate("a", 256))
        |> Map.put(:email, String.duplicate("a", 256))
        |> Map.put(:password, String.duplicate("a", 101))

      changeset = User.changeset(%User{}, attrs)

      assert "should be at most 255 character(s)" in errors_on(changeset).name
      assert "should be at most 255 character(s)" in errors_on(changeset).lastname
      assert "should be at most 255 character(s)" in errors_on(changeset).email
      assert "should be at most 100 character(s)" in errors_on(changeset).password
    end

    test "changeset check basic email format" do
      attrs = Map.put(@valid_attrs, :email, "wrong@email")
      changeset = User.changeset(%User{}, attrs)

      assert "has invalid format" in errors_on(changeset).email
    end

    test "changeset check password confirmation" do
      attrs = Map.put(@valid_attrs, :password_confirmation, "wrong")
      changeset = User.changeset(%User{}, attrs)

      assert "does not match confirmation" in errors_on(changeset).password_confirmation
    end

    test "changeset hashes password when present" do
      changeset = User.changeset(%User{}, @valid_attrs)
      %{password_hash: password_hash} = changeset.changes

      assert Comeonin.Argon2.checkpw(@valid_attrs.password, password_hash)
    end

    test "changeset ignores blank password" do
      attrs = %{@valid_attrs | password: nil, password_confirmation: nil}
      changeset = User.changeset(%User{}, attrs)

      assert changeset.valid?
      refute changeset.changes[:password_hash]
    end

    test "create changeset with valid attributes" do
      changeset = User.create_changeset(%User{account_id: 1}, @valid_attrs)

      assert changeset.valid?
    end

    test "create changeset with invalid attributes" do
      changeset = User.create_changeset(%User{}, %{@valid_attrs | password: nil})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).password
    end

    test "password reset changeset with valid attributes" do
      changeset = User.password_reset_changeset(%User{}, @valid_attrs)

      assert changeset.valid?
    end

    test "password reset changeset with invalid attributes" do
      attrs = %{@valid_attrs | password: nil, password_confirmation: nil}
      changeset = User.password_reset_changeset(%User{}, attrs)

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).password
    end

    test "password reset token changeset" do
      changeset = User.password_reset_token_changeset(%User{})

      assert changeset.valid?
      assert changeset.changes[:password_reset_token]
      assert changeset.changes[:password_reset_sent_at]
    end
  end
end
