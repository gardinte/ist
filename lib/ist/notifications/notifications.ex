defmodule Ist.Notifications do
  alias Ist.Accounts.User
  alias Ist.Notifications.{Mailer, Email}

  def send_password_reset(%User{} = user) do
    user
    |> Email.password_reset()
    |> Mailer.deliver_later()
  end
end
