defmodule CoreWeb.PowInvitation.MailerView do
  use CoreWeb, :mailer_view

  def subject(:invitation, _assigns), do: "You've been invited"
end
