defmodule Ist.Accounts.Auth do
  alias Ist.Repo
  alias Ist.Accounts.User

  import Argon2, only: [verify_pass: 2, no_user_verify: 0]

  @doc false
  def authenticate_by_email_and_password(email, password) do
    user = Repo.get_by(User, email: email)

    cond do
      user && verify_pass(password, user.password_hash) ->
        {:ok, user}

      true ->
        no_user_verify()
        {:error, :unauthorized}
    end
  end
end
