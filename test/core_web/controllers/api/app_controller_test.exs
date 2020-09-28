defmodule CoreWeb.API.AppControllerTest do
  use CoreWeb.ConnCase

  alias Core.Applications

  @create_attrs %{
    name: "some-name",
  }
  @other_app_attrs %{
    name: "some-other-name",
  }
  @team_attrs %{
    name: "some-name",
  }
  @role_attrs %{
    name: "some-name",
    permissions: %{
      "scope" => "admin",
    }
  }
  @other_role_attrs %{
    name: "other-name",
    permissions: %{
      "scope" => "none",
    }
  }
  @instance_attrs %{
    name: "alternate",
    auto_reconfigure: true,
    keep_deploys: 5,
  }

  setup %{conn: conn} do
    {:ok, user} =
      %Core.Accounts.User{}
      |> Core.Accounts.User.changeset(%{
        username: "some_username",
        password: "some password",
        password_confirmation: "some password",
        email: "some@email.address",
      })
      |> Core.Accounts.User.auth_token_changeset(%{
        authentication_token: "some_value",
      })
      |> Core.Repo.insert()
    {:ok, other_user} =
      %Core.Accounts.User{}
      |> Core.Accounts.User.changeset(%{
        username: "other_username",
        password: "other password",
        password_confirmation: "other password",
        email: "other@email.address",
      })
      |> Core.Accounts.User.auth_token_changeset(%{
        authentication_token: "other_value",
      })
      |> Core.Repo.insert()
    {:ok, team} = Core.Accounts.create_team(@team_attrs)
    {:ok, role} = Core.Accounts.create_role(@role_attrs)
    {:ok, other_role} = Core.Accounts.create_role(@other_role_attrs)
    {:ok, _membership} = Core.Accounts.create_team_membership(%{user_id: user.id, team_id: team.id, role_id: role.id})
    {:ok, _other_membership} = Core.Accounts.create_team_membership(%{user_id: other_user.id, team_id: team.id, role_id: other_role.id})
    {:ok, app} = Applications.create_app(Map.put(@create_attrs, :user_id, user.id))
    {:ok, other_app} = Applications.create_app(@other_app_attrs)
    {:ok, team_app} = Applications.create_app(Map.put(@create_attrs, :team_id, team.id))
    {:ok, instance} = Applications.create_instance(Map.put(@instance_attrs, :app_id, team_app.id))
    {:ok, _access} = Applications.create_instance_access(%{instance_id: instance.id, user_id: other_user.id, role_id: role.id})
    {
      :ok,
      user: user,
      team: team,
      app: app,
      other_app: other_app,
      team_app: team_app,
      instance: instance,
      conn:
        conn
        |> put_req_header("accept", "application/json")
    }
  end

  describe "index" do
    test "lists all user apps without ci orgument", %{conn: conn, app: app} do
      conn = get(conn |> put_req_header("x-auth-token", "some_value"), Routes.api_app_path(conn, :index))
      assert json_response(conn, 200) == [%{
        "auto_reconfigure" => false,
        "id" => app.id,
        "name" => "some-name",
        "state" => "creating",
        "timezone" => "UTC"
      }]
    end

    test "lists all team apps with ci argument", %{conn: conn, team_app: team_app} do
      conn = get(conn |> put_req_header("x-auth-token", "some_value"), Routes.api_app_path(conn, :index) <> "?ci=some-name")
      assert json_response(conn, 200) == [%{
        "auto_reconfigure" => false,
        "id" => team_app.id,
        "name" => "some-name",
        "state" => "creating",
        "timezone" => "UTC"
      }]
    end

    test "lists nothing with invalid ci argument", %{conn: conn} do
      conn = get(conn |> put_req_header("x-auth-token", "some_value"), Routes.api_app_path(conn, :index) <> "?ci=invalid-name")
      assert json_response(conn, 200) == []
    end

    test "lists nothing when user has no apps", %{conn: conn} do
      conn = get(conn |> put_req_header("x-auth-token", "other_value"), Routes.api_app_path(conn, :index))
      assert json_response(conn, 200) == []
    end

    test "lists nothing when user has no team access", %{conn: conn} do
      conn = get(conn |> put_req_header("x-auth-token", "other_value"), Routes.api_app_path(conn, :index) <> "?ci=some-name")
      assert json_response(conn, 200) == []
    end
  end

  describe "show" do
    test "returns an error with an invalid app ID", %{conn: conn} do
      conn = get(conn |> put_req_header("x-auth-token", "some_value"), Routes.api_app_path(conn, :show, "00000000-0000-0000-0000-000000000000"))
      assert json_response(conn, 404) == %{"errors" => ["App not found, or you don't have permission to access it."]}
    end

    test "returns an error with someone else's app ID", %{conn: conn, other_app: other_app} do
      conn = get(conn |> put_req_header("x-auth-token", "some_value"), Routes.api_app_path(conn, :show, other_app.id))
      assert json_response(conn, 404) == %{"errors" => ["App not found, or you don't have permission to access it."]}
    end

    test "returns an error with an invalid app name", %{conn: conn} do
      conn = get(conn |> put_req_header("x-auth-token", "some_value"), Routes.api_app_path(conn, :show, "invalid-name"))
      assert json_response(conn, 404) == %{"errors" => ["App not found, or you don't have permission to access it."]}
    end

    test "returns an error with an invalid team name", %{conn: conn} do
      conn = get(conn |> put_req_header("x-auth-token", "some_value"), Routes.api_app_path(conn, :show, "some-name") <> "?ci=invalid-name")
      assert json_response(conn, 404) == %{"errors" => ["App not found, or you don't have permission to access it."]}
    end

    test "returns an error with an invalid app name but a valid team name", %{conn: conn} do
      conn = get(conn |> put_req_header("x-auth-token", "some_value"), Routes.api_app_path(conn, :show, "invalid-name") <> "?ci=some-name")
      assert json_response(conn, 404) == %{"errors" => ["App not found, or you don't have permission to access it."]}
    end

    test "returns an error with a valid team and app name, but a restricted user", %{conn: conn} do
      conn = get(conn |> put_req_header("x-auth-token", "other_value"), Routes.api_app_path(conn, :show, "some-name") <> "?ci=some-name")
      assert json_response(conn, 404) == %{"errors" => ["App not found, or you don't have permission to access it."]}
    end

    test "returns a single user app by ID", %{conn: conn, app: app} do
      conn = get(conn |> put_req_header("x-auth-token", "some_value"), Routes.api_app_path(conn, :show, app.id))
      assert json_response(conn, 200) == %{
        "auto_reconfigure" => false,
        "id" => app.id,
        "name" => "some-name",
        "state" => "creating",
        "timezone" => "UTC"
      }
    end

    test "returns a single user app by name without ci argument", %{conn: conn, app: app} do
      conn = get(conn |> put_req_header("x-auth-token", "some_value"), Routes.api_app_path(conn, :show, "some-name"))
      assert json_response(conn, 200) == %{
        "auto_reconfigure" => false,
        "id" => app.id,
        "name" => "some-name",
        "state" => "creating",
        "timezone" => "UTC"
      }
    end

    test "returns a single team app by ID", %{conn: conn, team_app: team_app} do
      conn = get(conn |> put_req_header("x-auth-token", "some_value"), Routes.api_app_path(conn, :show, team_app.id))
      assert json_response(conn, 200) == %{
        "auto_reconfigure" => false,
        "id" => team_app.id,
        "name" => "some-name",
        "state" => "creating",
        "timezone" => "UTC"
      }
    end

    test "returns a single team app by name with ci argument", %{conn: conn, team_app: team_app} do
      conn = get(conn |> put_req_header("x-auth-token", "some_value"), Routes.api_app_path(conn, :show, "some-name") <> "?ci=some-name")
      assert json_response(conn, 200) == %{
        "auto_reconfigure" => false,
        "id" => team_app.id,
        "name" => "some-name",
        "state" => "creating",
        "timezone" => "UTC"
      }
    end

    test "returns a correct team app instance by ID", %{conn: conn, team_app: team_app} do
      conn = get(conn |> put_req_header("x-auth-token", "some_value"), Routes.api_app_path(conn, :show, team_app.id) <> "?instance=alternate")
      assert json_response(conn, 200) == %{
        "auto_reconfigure" => true,
        "id" => team_app.id,
        "name" => "some-name",
        "state" => "creating",
        "timezone" => "UTC"
      }
    end

    test "returns a correct team app instance by ID with restricted user", %{conn: conn, team_app: team_app} do
      conn = get(conn |> put_req_header("x-auth-token", "other_value"), Routes.api_app_path(conn, :show, team_app.id) <> "?instance=alternate")
      assert json_response(conn, 200) == %{
        "auto_reconfigure" => true,
        "id" => team_app.id,
        "name" => "some-name",
        "state" => "creating",
        "timezone" => "UTC"
      }
    end

    test "returns a correct team app instance by name with ci argument", %{conn: conn, team_app: team_app} do
      conn = get(conn |> put_req_header("x-auth-token", "some_value"), Routes.api_app_path(conn, :show, "some-name") <> "?ci=some-name&instance=alternate")
      assert json_response(conn, 200) == %{
        "auto_reconfigure" => true,
        "id" => team_app.id,
        "name" => "some-name",
        "state" => "creating",
        "timezone" => "UTC"
      }
    end

    test "returns a correct team app instance by name with ci argument and restricted user", %{conn: conn, team_app: team_app} do
      conn = get(conn |> put_req_header("x-auth-token", "other_value"), Routes.api_app_path(conn, :show, "some-name") <> "?ci=some-name&instance=alternate")
      assert json_response(conn, 200) == %{
        "auto_reconfigure" => true,
        "id" => team_app.id,
        "name" => "some-name",
        "state" => "creating",
        "timezone" => "UTC"
      }
    end
  end
end
