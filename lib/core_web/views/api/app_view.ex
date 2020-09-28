defmodule CoreWeb.API.AppView do
  use CoreWeb, :view
  alias CoreWeb.API.AppView

  def render("index.json", %{apps: apps}) do
    render_many(apps, AppView, "app.json")
  end

  def render("show.json", %{app: app}) do
    render_one(app, AppView, "app.json")
  end

  def render("app.json", %{app: app}) do
    %{id: app.id,
      name: app.name,
      timezone: app.instance |> Map.get(:timezone, "UTC"),
      state: app.instance |> Map.get(:state, "unknown"),
      auto_reconfigure: app.instance |> Map.get(:auto_reconfigure, false)}
  end
end
