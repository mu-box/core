defmodule CoreWeb.InstanceController do
  use CoreWeb, :controller

  alias Core.Applications
  alias Core.Applications.Instance

  def new(conn, %{"team_id" => team_id, "app_id" => app_id}) do
    app = Applications.get_app!(app_id) |> Core.Repo.preload([:team])
    changeset = Applications.change_instance(%Instance{})
    render(conn, "new.html", changeset: changeset, app: app, action: Routes.team_app_instance_path(conn, :create, team_id, app))
  end

  def create(conn, %{"team_id" => team_id, "app_id" => app_id, "instance" => instance_params}) do
    case Applications.create_instance(Map.merge(instance_params, %{"app_id" => app_id})) do
      {:ok, instance} ->
        conn
        |> put_flash(:info, "Instance created successfully.")
        |> redirect(to: Routes.team_app_instance_path(conn, :show, team_id, app_id, instance))

      {:error, %Ecto.Changeset{} = changeset} ->
        app = Applications.get_app!(app_id) |> Core.Repo.preload([:team])
        render(conn, "new.html", changeset: changeset, app: app, action: Routes.team_app_instance_path(conn, :create, team_id, app_id))
    end
  end

  def show(conn, %{"app_id" => app_id, "id" => id}) do
    instance = Applications.get_instance!(id) |> Core.Repo.preload([app: [:team], access: [:user, :role]])
    render(conn, "show.html", instance: instance, app_id: app_id)
  end

  def edit(conn, %{"app_id" => _app_id, "id" => id} = params) do
    instance = Applications.get_instance!(id) |> Core.Repo.preload([:app])
    changeset = Applications.change_instance(instance)
    action = if Map.has_key?(params, "team_id") do
      Routes.team_app_instance_path(conn, :update, Map.get(params, "team_id"), instance.app, instance)
    else
      Routes.app_instance_path(conn, :update, instance.app, instance)
    end
    render(conn, "edit.html", instance: instance, changeset: changeset, app: instance.app |> Core.Repo.preload([:team]), action: action)
  end

  def update(conn, %{"app_id" => _app_id, "id" => id, "instance" => instance_params} = params) do
    instance = Applications.get_instance!(id) |> Core.Repo.preload([:app])
    action = if Map.has_key?(params, "team_id") do
      Routes.team_app_instance_path(conn, :update, Map.get(params, "team_id"), instance.app, instance)
    else
      Routes.app_instance_path(conn, :update, instance.app, instance)
    end

    case Applications.update_instance(instance, instance_params) do
      {:ok, instance} ->
        case Applications.update_app(instance.app, instance_params["app"]) do
          {:ok, app} ->
            target = if app.team_id do
              Routes.team_app_instance_path(conn, :show, app.team_id, app, instance)
            else
              Routes.app_instance_path(conn, :show, app, instance)
            end
            conn
            |> put_flash(:info, "Instance updated successfully.")
            |> redirect(to: target)

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit.html", instance: instance, changeset: changeset, app: instance.app |> Core.Repo.preload([:team]), action: action)
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", instance: instance, changeset: changeset, app: instance.app |> Core.Repo.preload([:team]), action: action)
    end
  end

  def delete(conn, %{"app_id" => app_id, "id" => id}) do
    app = Applications.get_app!(app_id) |> Core.Repo.preload([:instances])
    instance = Applications.get_instance!(id)
    target = if !!app.team_id do
      if instance.name == "default" do
        Routes.team_path(conn, :show, app.team_id)
      else
        Routes.team_app_path(conn, :show, app.team_id, app)
      end
    else
      Routes.dash_path(conn, :index)
    end
    type = if instance.name == "default" do
      Enum.each app.instances, fn (instance) ->
        {:ok, _instance} = Applications.delete_instance(instance)
      end
      {:ok, _app} = Applications.delete_app(app)
      "App"
    else
      {:ok, _instance} = Applications.delete_instance(instance)
      "Instance"
    end

    conn
    |> put_flash(:info, type <> " deleted successfully.")
    |> redirect(to: target)
  end
end
