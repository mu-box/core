defmodule CoreWeb.PageControllerTest do
  use CoreWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Microbox!"
  end
end
