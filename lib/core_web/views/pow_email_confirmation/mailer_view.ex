defmodule CoreWeb.PowEmailConfirmation.MailerView do
  use CoreWeb, :mailer_view

  def subject(:email_confirmation, _assigns), do: "Confirm your email address"
end
