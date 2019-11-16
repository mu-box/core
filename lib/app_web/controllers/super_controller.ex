defmodule AppWeb.SuperController do
  use AppWeb, :controller
  alias App.{Repo, Users.User}
  import Ecto.Query

  def index(conn, _params) do
    render conn, "index.html", %{
      current_user: conn.assigns.current_user,
      users: Repo.all(from u in User, where: u.superuser == false),
      supers: Repo.all(from u in User, where: u.superuser == true)
    }
  end
end
