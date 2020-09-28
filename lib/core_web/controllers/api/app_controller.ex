defmodule CoreWeb.API.AppController do
  use CoreWeb, :controller

  alias Core.Applications

  action_fallback CoreWeb.FallbackController

  def index(%{assigns: %{current_user: user}} = conn, params) do
    apps = if Map.has_key?(params, "ci") do
      try do
        Map.get(params, "ci")
        |> Core.Accounts.get_team_by_slug!()
        |> team_apps(user)
      rescue Ecto.NoResultsError ->
        []
      end
    else
      user_apps(user)
    end
    |> Core.Repo.preload([:instances])
    |> Enum.map(fn (app) ->
      Map.put(app, :instance, app.instances |> Enum.find(%Core.Applications.Instance{}, fn (instance) -> instance.name == "default" end))
    end)
    render(conn, "index.json", apps: apps)
  end

  def show(%{assigns: %{current_user: user}} = conn, %{"id" => id} = params) do
    app = try do
      Applications.get_app(id)
    rescue
      Ecto.Query.CastError ->
        if Map.has_key?(params, "ci") do
          try do
            Map.get(params, "ci")
            |> Core.Accounts.get_team_by_slug!()
            |> Applications.get_app_by_team_and_name!(id)
          rescue
            Ecto.NoResultsError ->
              %Core.Applications.App{}
          end
        else
          try do
            Applications.get_app_by_user_and_name!(user, id)
          rescue
            Ecto.NoResultsError ->
              %Core.Applications.App{}
          end
        end
    end
    |> Core.Repo.preload([:instances])

    if is_nil(app) do
      conn
      |> put_status(404)
      |> put_view(CoreWeb.APIView)
      |> render("error.json", message: "App not found, or you don't have permission to access it.")
    else
      instance_name = if Map.has_key?(params, "instance") do
        Map.get(params, "instance")
      else
        "default"
      end

      app = app
        |> Map.put(:instance, app.instances |> Enum.find(%Core.Applications.Instance{}, fn (instance) -> instance.name == instance_name end))

      user_apps(user) ++ user_team_apps(user) ++ user_instance_apps(user, instance_name)
      |> Enum.any?(fn a -> a.id == app.id end)
      |> if do
        render(conn, "show.json", app: app)
      else
        conn
        |> put_status(404)
        |> put_view(CoreWeb.APIView)
        |> render("error.json", message: "App not found, or you don't have permission to access it.")
      end
    end
  end

  defp user_apps(user) do
    user
    |> Core.Repo.preload([:apps])
    |> Map.get(:apps)
  end

  defp user_team_apps(user) do
    user
    |> Core.Repo.preload([:teams])
    |> Map.get(:teams)
    |> Enum.flat_map(fn (team) -> team_apps(team, user) end)
  end

  defp team_apps(team, user) do
    if Core.Accounts.can_access_team(user, team, "scope", "read") do
      team
      |> Core.Repo.preload([:apps])
      |> Map.get(:apps)
    else
      []
    end
  end

  defp user_instance_apps(user, instance_name) do
    user
    |> Core.Repo.preload([:instances])
    |> Map.get(:instances)
    |> Enum.filter(fn (instance) -> instance.name == instance_name end)
    |> Enum.flat_map(fn (instance) -> instance_apps(instance, user) end)
  end

  defp instance_apps(instance, user) do
    if Core.Accounts.can_access_instance(user, instance, "scope", "read") do
      [instance
      |> Core.Repo.preload([:app])
      |> Map.get(:app)]
    else
      []
    end
  end
end
