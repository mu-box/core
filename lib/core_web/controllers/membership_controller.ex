defmodule CoreWeb.MembershipController do
  use CoreWeb, :controller

  alias Core.Accounts
  alias Core.Accounts.TeamMembership

  def new(conn, %{"team_id" => team_id}) do
    case Core.Accounts.can_access_team(Pow.Plug.current_user(conn), Core.Accounts.get_team!(team_id), "scope", "admin") do
      true ->
        changeset = Accounts.change_team_membership(%TeamMembership{})
        render(conn, "new.html", team_id: team_id, changeset: changeset)
      _else ->
        conn
        |> put_flash(:info, "That page is not available.")
        |> redirect(to: Routes.team_path(conn, :show, team_id))
    end
  end

  def create(conn, %{"team_id" => team_id, "team_membership" => team_membership_params}) do
    case Core.Accounts.can_access_team(Pow.Plug.current_user(conn), Core.Accounts.get_team!(team_id), "scope", "admin") do
      true ->
        case Accounts.create_team_membership(team_membership_params) do
          {:ok, _team_membership} ->
            conn
            |> put_flash(:info, "Team membership created successfully.")
            |> redirect(to: Routes.team_path(conn, :show, team_id))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "new.html", team_id: team_id, changeset: changeset)
        end
      _else ->
        conn
        |> put_flash(:info, "That page is not available.")
        |> redirect(to: Routes.team_path(conn, :show, team_id))
    end
  end

  def edit(conn, %{"team_id" => team_id, "id" => id}) do
    case Core.Accounts.can_access_team(Pow.Plug.current_user(conn), Core.Accounts.get_team!(team_id), "scope", "admin") do
      true ->
        team_membership = Accounts.get_team_membership!(id)
        changeset = Accounts.change_team_membership(team_membership)
        render(conn, "edit.html", team_id: team_id, team_membership: team_membership, changeset: changeset)
      _else ->
        conn
        |> put_flash(:info, "That page is not available.")
        |> redirect(to: Routes.team_path(conn, :show, team_id))
    end
  end

  def update(conn, %{"team_id" => team_id, "id" => id, "team_membership" => team_membership_params}) do
    case Core.Accounts.can_access_team(Pow.Plug.current_user(conn), Core.Accounts.get_team!(team_id), "scope", "admin") do
      true ->
        team_membership = Accounts.get_team_membership!(id)

        case Accounts.update_team_membership(team_membership, team_membership_params) do
          {:ok, _team_membership} ->
            conn
            |> put_flash(:info, "Team membership updated successfully.")
            |> redirect(to: Routes.team_path(conn, :show, team_id))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit.html", team_id: team_id, team_membership: team_membership, changeset: changeset)
        end
      _else ->
        conn
        |> put_flash(:info, "That page is not available.")
        |> redirect(to: Routes.team_path(conn, :show, team_id))
    end
  end

  def delete(conn, %{"team_id" => team_id, "id" => id}) do
    case Core.Accounts.can_access_team(Pow.Plug.current_user(conn), Core.Accounts.get_team!(team_id), "scope", "admin") do
      true ->
        team_membership = Accounts.get_team_membership!(id)
        {:ok, _team_membership} = Accounts.delete_team_membership(team_membership)

        conn
        |> put_flash(:info, "Team membership deleted successfully.")
        |> redirect(to: Routes.team_path(conn, :show, team_id))
      _else ->
        conn
        |> put_flash(:info, "That page is not available.")
        |> redirect(to: Routes.team_path(conn, :show, team_id))
    end
  end
end
