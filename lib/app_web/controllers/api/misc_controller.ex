defmodule AppWeb.API.MiscController do
  use AppWeb, :controller

  action_fallback AppWeb.API.FallbackController

  def version(conn, _params) do
    conn
    |> put_view(AppWeb.APIView)
    |> render("version.json", version: "1.0.0")
  end
end
