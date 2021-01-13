defmodule CoreWeb.API.ComponentControllerTest do
  use CoreWeb.ConnCase

  alias Core.Components
  alias Core.Components.Component

  @create_attrs %{
    behaviors: [],
    category: "some category",
    current_generation: 42,
    deploy_strategy: "some deploy_strategy",
    horizontal: true,
    name: "some name",
    port: 42,
    redundant: true,
    repair_strategy: "some repair_strategy",
    uid: "some uid"
  }
  @update_attrs %{
    behaviors: [],
    category: "some updated category",
    current_generation: 43,
    deploy_strategy: "some updated deploy_strategy",
    horizontal: false,
    name: "some updated name",
    port: 43,
    redundant: false,
    repair_strategy: "some updated repair_strategy",
    uid: "some updated uid"
  }
  @invalid_attrs %{behaviors: nil, category: nil, current_generation: nil, deploy_strategy: nil, horizontal: nil, name: nil, port: nil, redundant: nil, repair_strategy: nil, uid: nil}

  def fixture(:component) do
    {:ok, component} = Components.create_component(@create_attrs)
    component
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all components", %{conn: conn} do
      conn = get(conn, Routes.api_component_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create component" do
    test "renders component when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_component_path(conn, :create), component: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_component_path(conn, :show, id))

      assert %{
               "id" => id,
               "behaviors" => [],
               "category" => "some category",
               "current_generation" => 42,
               "deploy_strategy" => "some deploy_strategy",
               "horizontal" => true,
               "name" => "some name",
               "port" => 42,
               "redundant" => true,
               "repair_strategy" => "some repair_strategy",
               "uid" => "some uid"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_component_path(conn, :create), component: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update component" do
    setup [:create_component]

    test "renders component when data is valid", %{conn: conn, component: %Component{id: id} = component} do
      conn = put(conn, Routes.api_component_path(conn, :update, component), component: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_component_path(conn, :show, id))

      assert %{
               "id" => id,
               "behaviors" => [],
               "category" => "some updated category",
               "current_generation" => 43,
               "deploy_strategy" => "some updated deploy_strategy",
               "horizontal" => false,
               "name" => "some updated name",
               "port" => 43,
               "redundant" => false,
               "repair_strategy" => "some updated repair_strategy",
               "uid" => "some updated uid"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, component: component} do
      conn = put(conn, Routes.api_component_path(conn, :update, component), component: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete component" do
    setup [:create_component]

    test "deletes chosen component", %{conn: conn, component: component} do
      conn = delete(conn, Routes.api_component_path(conn, :delete, component))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_component_path(conn, :show, component))
      end
    end
  end

  defp create_component(_) do
    component = fixture(:component)
    {:ok, component: component}
  end
end
