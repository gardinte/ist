defmodule Ist.Accounts.UserRepoTest do
  use Ist.DataCase

  describe "user" do
    alias Ist.Accounts.User

    @valid_attrs %{
      email: "some@email.com",
      lastname: "some lastname",
      name: "some name",
      password: "123456"
    }

    test "converts unique constraint on email to error" do
      {:ok, user, _} = fixture(:user, @valid_attrs)
      attrs = Map.put(@valid_attrs, :email, user.email)
      changeset = User.create_changeset(%User{account_id: user.account_id}, attrs)

      expected = {
        "has already been taken",
        [validation: :unsafe_unique, fields: [:email]]
      }

      assert expected == changeset.errors[:email]
    end
  end
end
