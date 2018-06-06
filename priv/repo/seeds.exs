# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Ist.Repo.insert!(%Ist.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{:ok, account} =
  Ist.Accounts.create_account(%{
    name: "Default",
    db_prefix: "default"
  })

session = %Ist.Accounts.Session{account: account}

{:ok, _} =
  Ist.Accounts.create_user(session, %{
    name: "Admin",
    lastname: "Admin",
    email: "admin@ist.com",
    password: "123456"
  })
