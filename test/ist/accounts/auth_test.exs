defmodule Ist.Accounts.AuthTest do
  use Ist.DataCase

  describe "auth" do
    alias Ist.Accounts.Auth

    @valid_attrs %{
      email: "some@email.com",
      lastname: "some lastname",
      name: "some name",
      password: "123456"
    }

    test "authenticate_by_email_and_password/2 returns :ok with valid credentials" do
      {:ok, user, _} = fixture(:user, @valid_attrs)
      email = @valid_attrs.email
      password = @valid_attrs.password
      {:ok, auth_user} = Auth.authenticate_by_email_and_password(email, password)

      assert auth_user == user
    end

    test "authenticate_by_email_and_password/2 returns :error with invalid credentials" do
      email = @valid_attrs.email
      password = "wrong"

      # Create user just to be sure
      fixture(:user, @valid_attrs)

      assert {:error, :unauthorized} == Auth.authenticate_by_email_and_password(email, password)
    end

    test "authenticate_by_email_and_password/2 returns :error with invalid email" do
      email = "invalid@email.com"
      password = @valid_attrs.password

      assert {:error, :unauthorized} == Auth.authenticate_by_email_and_password(email, password)
    end
  end
end
