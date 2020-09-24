defmodule CoreWeb.PowResetPassword.MailerView do
  use CoreWeb, :mailer_view

  def subject(:reset_password, _assigns), do: "Reset password link"
end
