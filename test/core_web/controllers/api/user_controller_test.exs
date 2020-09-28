defmodule CoreWeb.API.UserControllerTest do
  use CoreWeb.ConnCase

  alias Core.Accounts

  setup %{conn: conn} do
    {:ok, user} =
      %Accounts.User{}
      |> Accounts.User.changeset(%{
        username: "some_username",
        password: "some password",
        password_confirmation: "some password",
        email: "some@email.address",
      })
      |> Accounts.User.auth_token_changeset(%{
        authentication_token: "some_value",
      })
      |> Core.Repo.insert()
    {:ok, user: user, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "token" do
    test "returns an error with insufficient data", %{conn: conn} do
      conn = get(conn, Routes.api_user_path(conn, :token))
      assert json_response(conn, 400) == %{"errors" => ["Incomplete or missing credentials."]}
    end

    test "returns an error with incorrect data", %{conn: conn} do
      conn = get(conn, Routes.api_user_path(conn, :token) <> "?slug=some_username&password=wrong%20password")
      assert json_response(conn, 404) == %{"errors" => ["User not found with those credentials."]}
    end

    test "provides the user's token", %{conn: conn, user: user} do
      conn = get(conn, Routes.api_user_path(conn, :token) <> "?slug=some_username&password=some%20password")
      assert json_response(conn, 200) == %{
        "id" => user.id,
        "authentication_token" => "some_value",
      }
    end
  end

  describe "show" do
    test "returns an error without a user token", %{conn: conn, user: user} do
      conn = get(conn, Routes.api_user_path(conn, :show, user.id))
      assert json_response(conn, 401) == %{"errors" => ["User not provided"]}
    end

    test "returns an error with an invalid user token", %{conn: conn, user: user} do
      conn = get(conn |> put_req_header("x-auth-token", "invalid_value"), Routes.api_user_path(conn, :show, user.id))
      assert json_response(conn, 401) == %{"errors" => ["User not found"]}
    end

    test "returns a single user", %{conn: conn, user: user} do
      conn = get(conn |> put_req_header("x-auth-token", "some_value"), Routes.api_user_path(conn, :show, user.id))
      assert json_response(conn, 200) == %{
        "id" => user.id,
        "username" => "some_username",
        "authentication_token" => "some_value",
        "email" => "some@email.address",
        "unconfirmed_email" => nil,
      }
    end
  end
end
