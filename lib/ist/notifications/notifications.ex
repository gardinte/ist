defmodule Ist.Notifications do
  alias Ist.Accounts.User
  alias Ist.Notifications.{Mailer, Email}

  def send_password_reset(%User{} = user) do
    Email.password_reset(user)
    |> Mailer.deliver_later()
  end
end
