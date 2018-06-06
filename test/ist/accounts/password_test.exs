defmodule Ist.Accounts.PasswordTest do
  use Ist.DataCase

  alias Ist.Repo
  alias Ist.Accounts.{Password, User}

  describe "get user by token" do
    test "get_user_by_token/1 returns the user with given token" do
      user = user_with_password_reset_token()

      assert Password.get_user_by_token(user.password_reset_token) == user
    end

    test "get_user_by_token/1 returns no result when token mismatch" do
      user = user_with_password_reset_token()

      refute Password.get_user_by_token("wrong-token") == user
    end

    test "get_user_by_token/1 returns no result when token is expired" do
      {:ok, user, _} = fixture(:user)

      user =
        user
        |> expired_password_reset_changeset()
        |> Repo.update!()

      refute Password.get_user_by_token(user.password_reset_token) == user
    end
  end

  describe "reset" do
    alias Ist.Notifications.Email
    use Bamboo.Test

    test "reset" do
      {:ok, user, _} = fixture(:user)

      refute user.password_reset_token

      Password.reset(user)

      user = Repo.get!(User, user.id)

      assert user.password_reset_token

      assert_delivered_email(Email.password_reset(user))
    end
  end

  defp user_with_password_reset_token do
    {:ok, user, _} = fixture(:user)

    user
    |> User.password_reset_token_changeset()
    |> Repo.update!()
  end

  defp expired_password_reset_changeset(%User{} = user) do
    sent_at =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.add(-6 * 60 * 60 - 1)

    attrs = %{
      password_reset_token: "WuxowusAqmrkmBYpTFcTxDUsaoqipm17u0mdrCcMCRJVJtF",
      password_reset_sent_at: sent_at
    }

    cast(user, attrs, [:password_reset_token, :password_reset_sent_at])
  end
end
