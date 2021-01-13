defmodule Core.ApplicationsTest do
  use Core.DataCase

  alias Core.Applications

  describe "apps" do
    alias Core.Applications.App

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def app_fixture(attrs \\ %{}) do
      {:ok, app} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Applications.create_app()

      app
    end

    test "list_apps/0 returns all apps" do
      app = app_fixture()
      assert Applications.list_apps() == [app]
    end

    test "get_app!/1 returns the app with given id" do
      app = app_fixture()
      assert Applications.get_app!(app.id) == app
    end

    test "create_app/1 with valid data creates a app" do
      assert {:ok, %App{} = app} = Applications.create_app(@valid_attrs)
      assert app.name == "some name"
    end

    test "create_app/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Applications.create_app(@invalid_attrs)
    end

    test "update_app/2 with valid data updates the app" do
      app = app_fixture()
      assert {:ok, %App{} = app} = Applications.update_app(app, @update_attrs)
      assert app.name == "some updated name"
    end

    test "update_app/2 with invalid data returns error changeset" do
      app = app_fixture()
      assert {:error, %Ecto.Changeset{}} = Applications.update_app(app, @invalid_attrs)
      assert app == Applications.get_app!(app.id)
    end

    test "delete_app/1 deletes the app" do
      app = app_fixture() |> Core.Repo.preload([:instances])
      for instance <- app.instances do
        instance |> Core.Repo.delete()
      end
      assert {:ok, %App{}} = Applications.delete_app(app)
      assert_raise Ecto.NoResultsError, fn -> Applications.get_app!(app.id) end
    end

    test "change_app/1 returns a app changeset" do
      app = app_fixture()
      assert %Ecto.Changeset{} = Applications.change_app(app)
    end
  end

  describe "instances" do
    alias Core.Applications.Instance

    @valid_attrs %{auto_reconfigure: true, keep_deploys: 42, name: "some name"}
    @update_attrs %{auto_reconfigure: false, keep_deploys: 43, name: "some updated name"}
    @invalid_attrs %{auto_reconfigure: nil, keep_deploys: nil, name: nil}

    def instance_fixture(attrs \\ %{}) do
      {:ok, instance} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Applications.create_instance()

      instance
    end

    setup do
      {:ok, app} = Core.Applications.App.changeset(%Core.Applications.App{}, %{name: "tester_app"}) |> Core.Repo.insert
      valid_attrs = Map.put(@valid_attrs, :app_id, app.id)
      {:ok, %{app: app, valid_attrs: valid_attrs}}
    end

    test "list_instances/0 returns all instances", %{valid_attrs: valid_attrs} do
      instance = instance_fixture(valid_attrs)
      assert Applications.list_instances() == [instance]
    end

    test "get_instance!/1 returns the instance with given id", %{valid_attrs: valid_attrs} do
      instance = instance_fixture(valid_attrs)
      assert Applications.get_instance!(instance.id) == instance
    end

    test "create_instance/1 with valid data creates a instance", %{valid_attrs: valid_attrs} do
      assert {:ok, %Instance{} = instance} = Applications.create_instance(valid_attrs)
      assert instance.auto_reconfigure == true
      assert instance.keep_deploys == 42
      assert instance.name == "some name"
    end

    test "create_instance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Applications.create_instance(@invalid_attrs)
    end

    test "update_instance/2 with valid data updates the instance", %{valid_attrs: valid_attrs} do
      instance = instance_fixture(valid_attrs)
      assert {:ok, %Instance{} = instance} = Applications.update_instance(instance, @update_attrs)
      assert instance.auto_reconfigure == false
      assert instance.keep_deploys == 43
      assert instance.name == "some updated name"
    end

    test "update_instance/2 with invalid data returns error changeset", %{valid_attrs: valid_attrs} do
      instance = instance_fixture(valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Applications.update_instance(instance, @invalid_attrs)
      assert instance == Applications.get_instance!(instance.id)
    end

    test "delete_instance/1 deletes the instance", %{valid_attrs: valid_attrs} do
      instance = instance_fixture(valid_attrs)
      assert {:ok, %Instance{}} = Applications.delete_instance(instance)
      assert_raise Ecto.NoResultsError, fn -> Applications.get_instance!(instance.id) end
    end

    test "change_instance/1 returns a instance changeset", %{valid_attrs: valid_attrs} do
      instance = instance_fixture(valid_attrs)
      assert %Ecto.Changeset{} = Applications.change_instance(instance)
    end
  end

  describe "instance_access" do
    alias Core.Applications.InstanceAccess

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{user_id: "00000000-0000-0000-0000-000000000000"}

    setup do
      {:ok, user} = Core.Accounts.User.changeset(%Core.Accounts.User{}, %{username: "tester_user", email: "tester@test.com", password: "Password", password_confirmation: "Password"}) |> Core.Repo.insert
      valid_attrs = Map.put(@valid_attrs, :user_id, user.id)
      {:ok, app} = Core.Applications.App.changeset(%Core.Applications.App{}, %{name: "tester_app"}) |> Core.Repo.insert
      {:ok, instance} = Core.Applications.Instance.changeset(%Core.Applications.Instance{}, %{app_id: app.id, name: "tester_instance"}) |> Core.Repo.insert
      valid_attrs = Map.put(valid_attrs, :instance_id, instance.id)
      {:ok, role} = Core.Accounts.Role.changeset(%Core.Accounts.Role{}, %{name: "Tester", permissions: %{"scope" => "admin"}}) |> Core.Repo.insert
      valid_attrs = Map.put(valid_attrs, :role_id, role.id)
      {:ok, %{user: user, valid_attrs: valid_attrs}}
    end

    def instance_access_fixture(attrs \\ %{}) do
      {:ok, instance_access} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Applications.create_instance_access()

      instance_access
    end

    test "list_instance_access/0 returns all instance_access", %{valid_attrs: valid_attrs} do
      instance_access = instance_access_fixture(valid_attrs)
      assert Applications.list_instance_access() == [instance_access]
    end

    test "get_instance_access!/1 returns the instance_access with given id", %{valid_attrs: valid_attrs} do
      instance_access = instance_access_fixture(valid_attrs)
      assert Applications.get_instance_access!(instance_access.id) == instance_access
    end

    test "create_instance_access/1 with valid data creates a instance_access", %{valid_attrs: valid_attrs} do
      assert {:ok, %InstanceAccess{} = instance_access} = Applications.create_instance_access(valid_attrs)
    end

    test "create_instance_access/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Applications.create_instance_access(@invalid_attrs)
    end

    test "update_instance_access/2 with valid data updates the instance_access", %{valid_attrs: valid_attrs} do
      instance_access = instance_access_fixture(valid_attrs)
      assert {:ok, %InstanceAccess{} = instance_access} = Applications.update_instance_access(instance_access, @update_attrs)
    end

    test "update_instance_access/2 with invalid data returns error changeset", %{valid_attrs: valid_attrs} do
      instance_access = instance_access_fixture(valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Applications.update_instance_access(instance_access, @invalid_attrs)
      assert instance_access == Applications.get_instance_access!(instance_access.id)
    end

    test "delete_instance_access/1 deletes the instance_access", %{valid_attrs: valid_attrs} do
      instance_access = instance_access_fixture(valid_attrs)
      assert {:ok, %InstanceAccess{}} = Applications.delete_instance_access(instance_access)
      assert_raise Ecto.NoResultsError, fn -> Applications.get_instance_access!(instance_access.id) end
    end

    test "change_instance_access/1 returns a instance_access changeset", %{valid_attrs: valid_attrs} do
      instance_access = instance_access_fixture(valid_attrs)
      assert %Ecto.Changeset{} = Applications.change_instance_access(instance_access)
    end
  end

  describe "services" do
    alias Core.Applications.Service

    @valid_attrs %{ip: "some ip", mode: "some mode", name: "some name", slug: "some slug", token: "some token", uid: "some uid", url: "some url"}
    @update_attrs %{ip: "some updated ip", mode: "some updated mode", name: "some updated name", slug: "some updated slug", token: "some updated token", uid: "some updated uid", url: "some updated url"}
    @invalid_attrs %{ip: nil, mode: nil, name: nil, slug: nil, token: nil, uid: nil, url: nil}

    def service_fixture(attrs \\ %{}) do
      {:ok, service} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Applications.create_service()

      service
    end

    test "list_services/0 returns all services" do
      service = service_fixture()
      assert Applications.list_services() == [service]
    end

    test "get_service!/1 returns the service with given id" do
      service = service_fixture()
      assert Applications.get_service!(service.id) == service
    end

    test "create_service/1 with valid data creates a service" do
      assert {:ok, %Service{} = service} = Applications.create_service(@valid_attrs)
      assert service.ip == "some ip"
      assert service.mode == "some mode"
      assert service.name == "some name"
      assert service.slug == "some slug"
      assert service.token == "some token"
      assert service.uid == "some uid"
      assert service.url == "some url"
    end

    test "create_service/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Applications.create_service(@invalid_attrs)
    end

    test "update_service/2 with valid data updates the service" do
      service = service_fixture()
      assert {:ok, %Service{} = service} = Applications.update_service(service, @update_attrs)
      assert service.ip == "some updated ip"
      assert service.mode == "some updated mode"
      assert service.name == "some updated name"
      assert service.slug == "some updated slug"
      assert service.token == "some updated token"
      assert service.uid == "some updated uid"
      assert service.url == "some updated url"
    end

    test "update_service/2 with invalid data returns error changeset" do
      service = service_fixture()
      assert {:error, %Ecto.Changeset{}} = Applications.update_service(service, @invalid_attrs)
      assert service == Applications.get_service!(service.id)
    end

    test "delete_service/1 deletes the service" do
      service = service_fixture()
      assert {:ok, %Service{}} = Applications.delete_service(service)
      assert_raise Ecto.NoResultsError, fn -> Applications.get_service!(service.id) end
    end

    test "change_service/1 returns a service changeset" do
      service = service_fixture()
      assert %Ecto.Changeset{} = Applications.change_service(service)
    end
  end
end
