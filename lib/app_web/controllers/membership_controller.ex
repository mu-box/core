defmodule AppWeb.MembershipController do
  use AppWeb, :controller

  alias App.Accounts
  alias App.Accounts.TeamMembership

  def new(conn, %{"team_id" => team_id}) do
    changeset = Accounts.change_team_membership(%TeamMembership{})
    render(conn, "new.html", team_id: team_id, changeset: changeset)
  end

  def create(conn, %{"team_id" => team_id, "team_membership" => team_membership_params}) do
    case Accounts.create_team_membership(team_membership_params) do
      {:ok, _team_membership} ->
        conn
        |> put_flash(:info, "Team role created successfully.")
        |> redirect(to: Routes.team_path(conn, :show, team_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", team_id: team_id, changeset: changeset)
    end
  end

  def edit(conn, %{"team_id" => team_id, "id" => id}) do
    team_membership = Accounts.get_team_membership!(id)
    changeset = Accounts.change_team_membership(team_membership)
    render(conn, "edit.html", team_id: team_id, team_membership: team_membership, changeset: changeset)
  end

  def update(conn, %{"team_id" => team_id, "id" => id, "team_membership" => team_membership_params}) do
    team_membership = Accounts.get_team_membership!(id)

    case Accounts.update_team_membership(team_membership, team_membership_params) do
      {:ok, _team_membership} ->
        conn
        |> put_flash(:info, "Team role updated successfully.")
        |> redirect(to: Routes.team_path(conn, :show, team_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", team_id: team_id, team_membership: team_membership, changeset: changeset)
    end
  end

  def delete(conn, %{"team_id" => team_id, "id" => id}) do
    team_membership = Accounts.get_team_membership!(id)
    {:ok, _team_membership} = Accounts.delete_team_membership(team_membership)

    conn
    |> put_flash(:info, "Team role deleted successfully.")
    |> redirect(to: Routes.team_path(conn, :show, team_id))
  end
end
