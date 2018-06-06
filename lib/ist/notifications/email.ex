defmodule Ist.Notifications.Email do
  use Bamboo.Phoenix, view: IstWeb.EmailView

  import Bamboo.Email
  import IstWeb.Gettext

  alias Ist.Accounts.User

  def password_reset(%User{} = user) do
    subject = dgettext("emails", "Password reset")

    base_email()
    |> to(user.email)
    |> subject(subject)
    |> render(:password_reset, user: user)
  end

  defp base_email() do
    new_email()
    |> from({gettext("Gardinte"), "support@gardinte.com"})
    |> put_layout({IstWeb.LayoutView, :email})
  end
end
