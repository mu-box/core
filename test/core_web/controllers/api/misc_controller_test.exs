defmodule CoreWeb.API.MiscControllerTest do
  use CoreWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json") |> put_req_header("x-auth-token", "some_value")}
  end

  describe "index" do
    test "returns the current API version", %{conn: conn} do
      conn = get(conn, Routes.api_misc_path(conn, :version))
      assert json_response(conn, 200) == %{
        "name" => "Microbox API",
        "version" => "1.0.0"
      }
    end
  end
end
