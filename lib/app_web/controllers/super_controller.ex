defmodule AppWeb.SuperController do
  use AppWeb, :controller
  alias App.Accounts

  def index(conn, _params) do
    render conn, "index.html", %{
      current_user: conn.assigns.current_user,
      users: Accounts.list_users(),
      supers: Accounts.super_users()
    }
  end
end
