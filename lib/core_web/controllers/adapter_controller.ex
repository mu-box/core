defmodule CoreWeb.AdapterController do
  use CoreWeb, :controller

  alias Core.{Accounts, Hosting}

  def create(conn, %{"user_id" => user_id}) do
    case Hosting.create_adapter(%{"user_id" => user_id}) do
      {:ok, _adapter} ->
        conn
        |> put_flash(:info, "Adapter created successfully.")
        |> redirect(to: Routes.dash_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def share_form(conn, %{"adapter_id" => adapter_id}) do
    user = Pow.Plug.current_user(conn) |> Core.Repo.preload([:teams])
    adapter = Hosting.get_adapter!(adapter_id)
    render(conn, "share.html", teams: user.teams |> Enum.reject(fn (team) ->
      team = team
      |> Core.Repo.preload([:hosting_adapters])

      team.hosting_adapters
      |> Enum.any?(fn (a) -> a.id == adapter_id end)
    end), adapter: adapter)
  end

  def share(conn, %{"adapter_id" => adapter_id, "adapter" => %{"team_id" => team_id}}) do
    # Just ensure these actually exist, first...
    Hosting.get_adapter!(adapter_id)
    Accounts.get_team!(team_id)

    %Hosting.TeamAdapter{}
    |> Hosting.TeamAdapter.changeset(%{hosting_adapter_id: adapter_id, team_id: team_id})
    |> Core.Repo.insert()

    redirect(conn, to: Routes.dash_path(conn, :index))
  end

  def unshare_form(conn, %{"adapter_id" => adapter_id}) do
    user = Pow.Plug.current_user(conn) |> Core.Repo.preload([:teams])
    adapter = Hosting.get_adapter!(adapter_id)
    render(conn, "unshare.html", teams: user.teams |> Enum.filter(fn (team) ->
      team = team
      |> Core.Repo.preload([:hosting_adapters])

      team.hosting_adapters
      |> Enum.any?(fn (a) -> a.id == adapter_id end)
    end), adapter: adapter)
  end

  def unshare(conn, %{"adapter_id" => adapter_id, "adapter" => %{"team_id" => team_id}}) do
    # Just ensure these actually exist, first...
    Hosting.get_adapter!(adapter_id)
    Accounts.get_team!(team_id)

    Core.Repo.get_by!(Hosting.TeamAdapter, hosting_adapter_id: adapter_id, team_id: team_id)
    |> Core.Repo.delete()

    redirect(conn, to: Routes.dash_path(conn, :index))
  end
end
