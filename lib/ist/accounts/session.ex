defmodule Ist.Accounts.Session do
  alias Ist.Accounts
  alias Ist.Accounts.{Account, User}

  defstruct account: %Account{}, user: %User{}

  @doc false
  def get_session(account_id, user_id)
      when is_nil(account_id) or is_nil(user_id) do
    nil
  end

  @doc false
  def get_session(account_id, user_id) do
    account = Accounts.get_account!(account_id)
    user = Accounts.get_user!(account, user_id)

    %__MODULE__{account: account, user: user}
  end
end
