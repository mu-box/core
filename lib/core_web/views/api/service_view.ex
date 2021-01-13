defmodule CoreWeb.API.ServiceView do
  use CoreWeb, :view
  alias CoreWeb.API.ServiceView

  def render("index.json", %{services: services}) do
    %{data: render_many(services, ServiceView, "service.json")}
  end

  def render("show.json", %{service: service}) do
    %{data: render_one(service, ServiceView, "service.json")}
  end

  def render("service.json", %{service: service}) do
    %{id: service.id,
      uid: service.uid,
      name: service.name,
      slug: service.slug,
      ip: service.ip,
      url: service.url,
      mode: service.mode,
      token: service.token}
  end
end
