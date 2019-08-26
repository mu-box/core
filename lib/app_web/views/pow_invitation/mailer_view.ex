defmodule AppWeb.PowInvitation.MailerView do
  use AppWeb, :mailer_view

  def subject(:invitation, _assigns), do: "You've been invited"
end
