defmodule AppWeb.API.UserView do
  use AppWeb, :view
  alias AppWeb.API.UserView

  def render("token.json", %{user: user}) do
    %{id: user.id,
      authentication_token: user.authentication_token}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      email: user.email,
      authentication_token: user.authentication_token,
      unconfirmed_email: user.unconfirmed_email}
  end
end
