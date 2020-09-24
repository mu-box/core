defmodule CoreWeb.PageController do
  use CoreWeb, :controller

  def index(conn, _params) do
    render conn, "index.html", current_user: conn.assigns.current_user
  end
end
