defmodule AppWeb.PowEmailConfirmation.MailerView do
  use AppWeb, :mailer_view

  def subject(:email_confirmation, _assigns), do: "Confirm your email address"
end
