defmodule CoreWeb.API.ServiceControllerTest do
  use CoreWeb.ConnCase

  alias Core.Applications
  alias Core.Applications.Service

  @create_attrs %{
    ip: "some ip",
    mode: "some mode",
    name: "some name",
    slug: "some slug",
    token: "some token",
    uid: "some uid",
    url: "some url"
  }
  @update_attrs %{
    ip: "some updated ip",
    mode: "some updated mode",
    name: "some updated name",
    slug: "some updated slug",
    token: "some updated token",
    uid: "some updated uid",
    url: "some updated url"
  }
  @invalid_attrs %{ip: nil, mode: nil, name: nil, slug: nil, token: nil, uid: nil, url: nil}

  def fixture(:service) do
    {:ok, service} = Applications.create_service(@create_attrs)
    service
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all services", %{conn: conn} do
      conn = get(conn, Routes.api_service_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create service" do
    test "renders service when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_service_path(conn, :create), service: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_service_path(conn, :show, id))

      assert %{
               "id" => id,
               "ip" => "some ip",
               "mode" => "some mode",
               "name" => "some name",
               "slug" => "some slug",
               "token" => "some token",
               "uid" => "some uid",
               "url" => "some url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_service_path(conn, :create), service: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update service" do
    setup [:create_service]

    test "renders service when data is valid", %{conn: conn, service: %Service{id: id} = service} do
      conn = put(conn, Routes.api_service_path(conn, :update, service), service: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_service_path(conn, :show, id))

      assert %{
               "id" => id,
               "ip" => "some updated ip",
               "mode" => "some updated mode",
               "name" => "some updated name",
               "slug" => "some updated slug",
               "token" => "some updated token",
               "uid" => "some updated uid",
               "url" => "some updated url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, service: service} do
      conn = put(conn, Routes.api_service_path(conn, :update, service), service: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete service" do
    setup [:create_service]

    test "deletes chosen service", %{conn: conn, service: service} do
      conn = delete(conn, Routes.api_service_path(conn, :delete, service))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_service_path(conn, :show, service))
      end
    end
  end

  defp create_service(_) do
    service = fixture(:service)
    {:ok, service: service}
  end
end
