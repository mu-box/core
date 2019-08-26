defmodule AppWeb.PowResetPassword.MailerView do
  use AppWeb, :mailer_view

  def subject(:reset_password, _assigns), do: "Reset password link"
end
