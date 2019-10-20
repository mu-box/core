defmodule AppWeb.SuperController do
  use AppWeb, :controller

  def index(conn, _params) do
    render conn, "index.html", current_user: conn.assigns.current_user
  end
end
