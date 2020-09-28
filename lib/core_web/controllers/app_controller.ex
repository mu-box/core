defmodule CoreWeb.AppController do
  use CoreWeb, :controller

  alias Core.Applications
  alias Core.Applications.App

  def new(conn, params) do
    action = if Map.has_key?(params, "team_id") do
      Routes.team_app_path(conn, :create, Map.get(params, "team_id"))
    else
      Routes.app_path(conn, :create)
    end
    changeset = Applications.change_app(%App{})
    render(conn, "new.html", changeset: changeset, action: action)
  end

  def create(%{assigns: %{current_user: user}} = conn, %{"app" => app_params} = params) do
    owner = if Map.has_key?(params, "team_id") do
      %{"team_id" => Map.get(params, "team_id")}
    else
      %{"user_id" => user.id}
    end
    action = if Map.has_key?(params, "team_id") do
      Routes.team_app_path(conn, :create, Map.get(params, "team_id"))
    else
      Routes.app_path(conn, :create)
    end
    case Applications.create_app(Map.merge(app_params, owner)) do
      {:ok, app} ->
        conn
        |> put_flash(:info, "App created successfully.")
        |> redirect(to: Routes.app_path(conn, :show, app))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, action: action)
    end
  end

  def show(conn, %{"id" => id} = params) do
    app = Applications.get_app!(id) |> Core.Repo.preload([:instances])
    instance = app
    |> Map.get(:instances)
    |> Enum.find(%Core.Applications.Instance{}, fn (instance) -> instance.name == "default" end)
    if !!app.team_id and Map.has_key?(params, "team_id") do
      render(conn, "show.html", app: app |> Core.Repo.preload([:team]))
    else
      if app.team_id do
        redirect(conn, to: Routes.team_app_path(conn, :show, app.team_id, app))
      else
        redirect(conn, to: Routes.app_instance_path(conn, :show, app, instance))
      end
    end
  end

  def edit(conn, %{"id" => id}) do
    app = Applications.get_app!(id)
    changeset = Applications.change_app(app)
    render(conn, "edit.html", app: app, changeset: changeset)
  end

  def update(conn, %{"id" => id, "app" => app_params} = params) do
    app = Applications.get_app!(id)
    target = if Map.has_key?(params, "team_id") do
      Routes.team_app_path(conn, :show, Map.get(params, "team_id"), app)
    else
      Routes.app_path(conn, :show, app)
    end
    case Applications.update_app(app, app_params) do
      {:ok, _app} ->
        conn
        |> put_flash(:info, "App updated successfully.")
        |> redirect(to: target)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", app: app, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id} = params) do
    app = Applications.get_app!(id)
    {:ok, _app} = Applications.delete_app(app)

    target = if Map.has_key?(params, "team_id") do
      Routes.team_path(conn, :show, Map.get(params, "team_id"))
    else
      Routes.dash_path(conn, :index, app)
    end
    conn
    |> put_flash(:info, "App deleted successfully.")
    |> redirect(to: target)
  end
end
