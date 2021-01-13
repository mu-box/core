defmodule CoreWeb.API.ComponentView do
  use CoreWeb, :view
  alias CoreWeb.API.ComponentView

  def render("index.json", %{components: components}) do
    %{data: render_many(components, ComponentView, "component.json")}
  end

  def render("show.json", %{component: component}) do
    %{data: render_one(component, ComponentView, "component.json")}
  end

  def render("component.json", %{component: component}) do
    %{id: component.id,
      name: component.name,
      uid: component.uid,
      category: component.category,
      current_generation: component.current_generation,
      deploy_strategy: component.deploy_strategy,
      repair_strategy: component.repair_strategy,
      behaviors: component.behaviors,
      port: component.port,
      horizontal: component.horizontal,
      redundant: component.redundant}
  end
end
