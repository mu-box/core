defmodule CoreWeb.TeamRoleControllerTest do
  use CoreWeb.ConnCase

  alias Core.Accounts

  @create_attrs %{role: "some role", username: "some username"}
  @update_attrs %{role: "some updated role", username: "some updated username"}
  @invalid_attrs %{role: nil, username: nil}

  def fixture(:team_role) do
    {:ok, team_role} = Accounts.create_team_role(@create_attrs)
    team_role
  end

  describe "index" do
    test "lists all team_roles", %{conn: conn} do
      conn = get(conn, Routes.team_role_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Team roles"
    end
  end

  describe "new team_role" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.team_role_path(conn, :new))
      assert html_response(conn, 200) =~ "New Team role"
    end
  end

  describe "create team_role" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.team_role_path(conn, :create), team_role: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.team_role_path(conn, :show, id)

      conn = get(conn, Routes.team_role_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Team role"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.team_role_path(conn, :create), team_role: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Team role"
    end
  end

  describe "edit team_role" do
    setup [:create_team_role]

    test "renders form for editing chosen team_role", %{conn: conn, team_role: team_role} do
      conn = get(conn, Routes.team_role_path(conn, :edit, team_role))
      assert html_response(conn, 200) =~ "Edit Team role"
    end
  end

  describe "update team_role" do
    setup [:create_team_role]

    test "redirects when data is valid", %{conn: conn, team_role: team_role} do
      conn = put(conn, Routes.team_role_path(conn, :update, team_role), team_role: @update_attrs)
      assert redirected_to(conn) == Routes.team_role_path(conn, :show, team_role)

      conn = get(conn, Routes.team_role_path(conn, :show, team_role))
      assert html_response(conn, 200) =~ "some updated role"
    end

    test "renders errors when data is invalid", %{conn: conn, team_role: team_role} do
      conn = put(conn, Routes.team_role_path(conn, :update, team_role), team_role: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Team role"
    end
  end

  describe "delete team_role" do
    setup [:create_team_role]

    test "deletes chosen team_role", %{conn: conn, team_role: team_role} do
      conn = delete(conn, Routes.team_role_path(conn, :delete, team_role))
      assert redirected_to(conn) == Routes.team_role_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.team_role_path(conn, :show, team_role))
      end
    end
  end

  defp create_team_role(_) do
    team_role = fixture(:team_role)
    {:ok, team_role: team_role}
  end
end
