defmodule CoreWeb.API.ServiceController do
  use CoreWeb, :controller

  alias Core.Applications

  action_fallback CoreWeb.FallbackController

  def index(conn, _params) do
    services = Applications.list_services()
    render(conn, "index.json", services: services)
  end

  def show(conn, %{"id" => id}) do
    service = Applications.get_service!(id)
    render(conn, "show.json", service: service)
  end
end
