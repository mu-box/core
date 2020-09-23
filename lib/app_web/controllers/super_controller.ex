defmodule AppWeb.SuperController do
  use AppWeb, :controller
  alias App.{Accounts, Hosting}

  def index(conn, _params) do
    render conn, "index.html", %{
      current_user: conn.assigns.current_user,
      users: Accounts.list_users(),
      supers: Accounts.super_users(),
      teams: Accounts.list_teams(),
      adapters: Hosting.list_adapters(),
    }
  end

  def make_global(conn, %{"adapter_id" => adapter_id}) do
    Hosting.get_adapter!(adapter_id)
    |> Hosting.Adapter.changeset(%{global: true})
    |> App.Repo.update()

    redirect(conn, to: Routes.super_path(conn, :index))
  end

  def make_local(conn, %{"adapter_id" => adapter_id}) do
    Hosting.get_adapter!(adapter_id)
    |> Hosting.Adapter.changeset(%{global: false})
    |> App.Repo.update()

    redirect(conn, to: Routes.super_path(conn, :index))
  end
end
