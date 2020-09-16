defmodule AppWeb.TeamController do
  use AppWeb, :controller

  alias App.Accounts
  alias App.Accounts.Team

  def new(conn, _params) do
    changeset = Accounts.change_team(%Team{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"team" => team_params}) do
    case Accounts.create_team(team_params) do
      {:ok, team} ->
        conn = conn
        |> put_flash(:info, "Team created successfully.")

        case Accounts.create_team_membership(%{
          team_id: team.id,
          user_id: Pow.Plug.current_user(conn).id,
          role_id: Accounts.get_role_by_name!("Owner").id
        }) do
          {:ok, _membership} ->
            conn
            |> redirect(to: Routes.team_path(conn, :show, team))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "new.html", changeset: changeset)
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    team = Accounts.get_team!(id) |> App.Repo.preload([:memberships])
    render(conn, "show.html", team: team)
  end

  def edit(conn, %{"id" => id}) do
    team = Accounts.get_team!(id)
    case App.Accounts.can_access_team(Pow.Plug.current_user(conn), team, "scope", "admin") do
      true ->
        changeset = Accounts.change_team(team)
        render(conn, "edit.html", team: team, changeset: changeset)
      _else ->
        conn
        |> put_flash(:info, "That page is not available.")
        |> redirect(to: Routes.team_path(conn, :show, id))
    end
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Accounts.get_team!(id)

    case App.Accounts.can_access_team(Pow.Plug.current_user(conn), team, "scope", "admin") do
      true ->
        case Accounts.update_team(team, team_params) do
          {:ok, team} ->
            conn
            |> put_flash(:info, "Team updated successfully.")
            |> redirect(to: Routes.team_path(conn, :show, team))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit.html", team: team, changeset: changeset)
        end
      _else ->
        conn
        |> put_flash(:info, "That page is not available.")
        |> redirect(to: Routes.team_path(conn, :show, id))
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Accounts.get_team!(id) |> App.Repo.preload([:memberships])
    case App.Accounts.can_access_team(Pow.Plug.current_user(conn), team, "scope", "admin") do
      true ->
        team.memberships |> Enum.each(fn (membership) -> Accounts.delete_team_membership(membership) end)
        {:ok, _team} = Accounts.delete_team(team)

        conn
        |> put_flash(:info, "Team deleted successfully.")
        |> redirect(to: Routes.dash_path(conn, :index))
      _else ->
        conn
        |> put_flash(:info, "That page is not available.")
        |> redirect(to: Routes.team_path(conn, :show, id))
    end
  end
end
