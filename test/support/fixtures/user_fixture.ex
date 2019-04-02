defmodule Ist.Support.Fixtures.UserFixture do
  alias Ist.Accounts.Session
  alias Ist.Accounts

  defmacro __using__(_opts) do
    quote do
      @user_attrs %{
        email: "some@email.com",
        lastname: "some lastname",
        name: "some name",
        password: "123456",
        password_confirmation: "123456"
      }

      def fixture(:user, attributes, %{account: account} = session) when is_map(session) do
        attributes = Enum.into(attributes, @user_attrs)
        {:ok, user} = Accounts.create_user(session, attributes)

        {:ok, %{user | password: nil}, account}
      end

      def fixture(:user, attributes, _) do
        account = fixture(:seed_account)
        session = %Session{account: account}

        fixture(:user, attributes, session)
      end
    end
  end
end
