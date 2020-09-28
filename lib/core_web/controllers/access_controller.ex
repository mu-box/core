defmodule CoreWeb.AccessController do
  use CoreWeb, :controller

  alias Core.Applications
  alias Core.Applications.InstanceAccess

  def new(conn, %{"team_id" => team_id, "app_id" => app_id, "instance_id" => instance_id}) do
    case Core.Accounts.can_access_team(Pow.Plug.current_user(conn), Core.Accounts.get_team!(team_id), "scope", "admin") do
      true ->
        changeset = Applications.change_instance_access(%InstanceAccess{})
        render(conn, "new.html", changeset: changeset, team: Core.Accounts.get_team!(team_id), app_id: app_id, instance_id: instance_id)
      _else ->
        conn
        |> put_flash(:info, "That page is not available.")
        |> redirect(to: Routes.team_app_instance_path(conn, :show, team_id, app_id, instance_id))
    end
  end

  def create(conn, %{"team_id" => team_id, "app_id" => app_id, "instance_id" => instance_id, "instance_access" => instance_access_params}) do
    case Core.Accounts.can_access_team(Pow.Plug.current_user(conn), Core.Accounts.get_team!(team_id), "scope", "admin") do
      true ->
        case Applications.create_instance_access(instance_access_params) do
          {:ok, _instance_access} ->
            conn
            |> put_flash(:info, "Instance access created successfully.")
            |> redirect(to: Routes.team_app_instance_path(conn, :show, team_id, app_id, instance_id))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "new.html", changeset: changeset, team: Core.Accounts.get_team!(team_id), app_id: app_id, instance_id: instance_id)
        end
      _else ->
        conn
        |> put_flash(:info, "That page is not available.")
        |> redirect(to: Routes.team_app_instance_path(conn, :show, team_id, app_id, instance_id))
    end
  end

  def edit(conn, %{"team_id" => team_id, "app_id" => app_id, "instance_id" => instance_id, "id" => id}) do
    case Core.Accounts.can_access_instance(Pow.Plug.current_user(conn), Core.Applications.get_instance!(instance_id), "scope", "admin") do
      true ->
        instance_access = Applications.get_instance_access!(id)
        changeset = Applications.change_instance_access(instance_access)
        render(conn, "edit.html", instance_access: instance_access, changeset: changeset, team: Core.Accounts.get_team!(team_id), app_id: app_id, instance_id: instance_id)
      _else ->
        conn
        |> put_flash(:info, "That page is not available.")
        |> redirect(to: Routes.team_app_instance_path(conn, :show, team_id, app_id, instance_id))
    end
  end

  def update(conn, %{"team_id" => team_id, "app_id" => app_id, "instance_id" => instance_id, "id" => id, "instance_access" => instance_access_params}) do
    case Core.Accounts.can_access_instance(Pow.Plug.current_user(conn), Core.Applications.get_instance!(instance_id), "scope", "admin") do
      true ->
        instance_access = Applications.get_instance_access!(id)

        case Applications.update_instance_access(instance_access, instance_access_params) do
          {:ok, _instance_access} ->
            conn
            |> put_flash(:info, "Instance access updated successfully.")
            |> redirect(to: Routes.team_app_instance_path(conn, :show, team_id, app_id, instance_id))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit.html", instance_access: instance_access, changeset: changeset, team: Core.Accounts.get_team!(team_id), app_id: app_id, instance_id: instance_id)
        end
      _else ->
        conn
        |> put_flash(:info, "That page is not available.")
        |> redirect(to: Routes.team_app_instance_path(conn, :show, team_id, app_id, instance_id))
    end
  end

  def delete(conn, %{"team_id" => team_id, "app_id" => app_id, "instance_id" => instance_id, "id" => id}) do
    case Core.Accounts.can_access_instance(Pow.Plug.current_user(conn), Core.Applications.get_instance!(instance_id), "scope", "admin") do
      true ->
        instance_access = Applications.get_instance_access!(id)
        {:ok, _instance_access} = Applications.delete_instance_access(instance_access)

        conn
        |> put_flash(:info, "Instance access deleted successfully.")
        |> redirect(to: Routes.team_app_instance_path(conn, :show, team_id, app_id, instance_id))
      _else ->
        conn
        |> put_flash(:info, "That page is not available.")
        |> redirect(to: Routes.team_app_instance_path(conn, :show, team_id, app_id, instance_id))
    end
    instance_access = Applications.get_instance_access!(id)
    {:ok, _instance_access} = Applications.delete_instance_access(instance_access)

    conn
    |> put_flash(:info, "Instance access deleted successfully.")
    |> redirect(to: Routes.team_app_instance_path(conn, :show, team_id, app_id, instance_id))
  end
end
