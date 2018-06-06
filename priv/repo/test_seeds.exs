# Reset
account = Ist.Repo.get_by(Ist.Accounts.Account, db_prefix: "test_account")

if account, do: {:ok, _} = Ist.Accounts.delete_account(account)

# Create

{:ok, _} =
  Ist.Accounts.create_account(%{
    name: "Test account",
    db_prefix: "test_account"
  })
