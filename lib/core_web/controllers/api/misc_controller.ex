defmodule CoreWeb.API.MiscController do
  use CoreWeb, :controller

  action_fallback CoreWeb.FallbackController

  def version(conn, _params) do
    conn
    |> put_view(CoreWeb.APIView)
    |> render("version.json", version: "1.0.0")
  end
end
