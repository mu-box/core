defmodule CoreWeb.API.ComponentController do
  use CoreWeb, :controller

  alias Core.Components
  alias Core.Components.Component

  action_fallback CoreWeb.FallbackController

  def index(conn, _params) do
    components = Components.list_components()
    render(conn, "index.json", components: components)
  end

  def create(conn, %{"component" => component_params}) do
    with {:ok, %Component{} = component} <- Components.create_component(component_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_component_path(conn, :show, component))
      |> render("show.json", component: component)
    end
  end

  def show(conn, %{"id" => id}) do
    component = Components.get_component!(id)
    render(conn, "show.json", component: component)
  end

  def update(conn, %{"id" => id, "component" => component_params}) do
    component = Components.get_component!(id)

    with {:ok, %Component{} = component} <- Components.update_component(component, component_params) do
      render(conn, "show.json", component: component)
    end
  end

  def delete(conn, %{"id" => id}) do
    component = Components.get_component!(id)

    with {:ok, %Component{}} <- Components.delete_component(component) do
      send_resp(conn, :no_content, "")
    end
  end
end
