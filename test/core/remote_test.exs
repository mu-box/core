defmodule Core.RemoteTest do
  use Core.DataCase

  alias Core.Remote

  @adapter_attrs %{name: "some_name"}
  @account_attrs %{name: "some_name"}
  @app_attrs %{name: "some_name"}
  @instance_attrs %{name: "alternate"}

  def adapter_fixture(attrs \\ %{}) do
    {:ok, user} =
      Core.Accounts.User.changeset(%Core.Accounts.User{}, %{
        username: "tester_user",
        email: "tester@test.com",
        password: "Password",
        password_confirmation: "Password"
      })
      |> Core.Repo.insert
    {:ok, adapter} =
      attrs
      |> Enum.into(%{user_id: user.id})
      |> Enum.into(@adapter_attrs)
      |> Core.Hosting.create_adapter()

    adapter
  end

  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(@account_attrs)
      |> Core.Hosting.create_account()

    account
  end

  def instance_fixture(attrs \\ %{}) do
    {:ok, app} =
      %{}
      |> Enum.into(@app_attrs)
      |> Core.Applications.create_app()
    {:ok, instance} =
      attrs
      |> Enum.into(%{app_id: app.id})
      |> Enum.into(@instance_attrs)
      |> Core.Applications.create_instance()

    instance
  end

  describe "servers" do
    alias Core.Remote.Server

    @region_attrs %{region: "1", name: "region 1"}
    @plan_attrs %{plan: "1", name: "plan 1"}
    @spec_attrs %{spec: "1", ram: 1, cpu: 1, disk: 20, transfer: 1, dollars_per_hr: 0.01, dollars_per_mo: 7.31}
    @valid_attrs %{external_ip: "some external_ip", internal_ip: "some internal_ip", name: "some name", server: "some server", status: "some status", token: "some token"}
    @update_attrs %{external_ip: "some updated external_ip", internal_ip: "some updated internal_ip", name: "some updated name", server: "some updated server", status: "some updated status", token: "some updated token"}
    @invalid_attrs %{external_ip: nil, internal_ip: nil, name: nil, server: nil, status: nil, token: nil}

    def spec_fixture(adapter_id, attrs \\ %{}) do
      {:ok, region} =
        %Core.Hosting.Region{hosting_adapter_id: adapter_id}
        |> Map.merge(@region_attrs)
        |> Core.Repo.insert()
      {:ok, plan} =
        %Core.Hosting.Plan{hosting_region_id: region.id}
        |> Map.merge(@plan_attrs)
        |> Core.Repo.insert()
      {:ok, spec} =
        %Core.Hosting.Spec{hosting_plan_id: plan.id}
        |> Map.merge(attrs)
        |> Map.merge(@spec_attrs)
        |> Core.Repo.insert()

      spec
    end

    def server_fixture(attrs \\ %{}) do
      adapter = adapter_fixture()
      account = account_fixture(%{hosting_adapter_id: adapter.id})
      instance = instance_fixture()
      spec = spec_fixture(adapter.id)
      {:ok, server} =
        attrs
        |> Enum.into(%{instance_id: instance.id, hosting_account_id: account.id, specs_id: spec.id})
        |> Enum.into(@valid_attrs)
        |> Remote.create_server()

      server
    end

    test "list_servers/0 returns all servers" do
      server = server_fixture()
      assert Remote.list_servers() == [server]
    end

    test "get_server!/1 returns the server with given id" do
      server = server_fixture()
      assert Remote.get_server!(server.id) == server
    end

    test "create_server/1 with valid data creates a server" do
      adapter = adapter_fixture()
      account = account_fixture(%{hosting_adapter_id: adapter.id})
      instance = instance_fixture()
      spec = spec_fixture(adapter.id)
      assert {:ok, %Server{} = server} = Remote.create_server(Enum.into(@valid_attrs, %{instance_id: instance.id, hosting_account_id: account.id, specs_id: spec.id}))
      assert server.external_ip == "some external_ip"
      assert server.internal_ip == "some internal_ip"
      assert server.name == "some name"
      assert server.server == "some server"
      assert server.status == "some status"
      assert server.token == "some token"
    end

    test "create_server/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Remote.create_server(@invalid_attrs)
    end

    test "update_server/2 with valid data updates the server" do
      server = server_fixture()
      assert {:ok, %Server{} = server} = Remote.update_server(server, @update_attrs)
      assert server.external_ip == "some updated external_ip"
      assert server.internal_ip == "some updated internal_ip"
      assert server.name == "some updated name"
      assert server.server == "some updated server"
      assert server.status == "some updated status"
      assert server.token == "some updated token"
    end

    test "update_server/2 with invalid data returns error changeset" do
      server = server_fixture()
      assert {:error, %Ecto.Changeset{}} = Remote.update_server(server, @invalid_attrs)
      assert server == Remote.get_server!(server.id)
    end

    test "delete_server/1 deletes the server" do
      server = server_fixture()
      assert {:ok, %Server{}} = Remote.delete_server(server)
      assert_raise Ecto.NoResultsError, fn -> Remote.get_server!(server.id) end
    end

    test "change_server/1 returns a server changeset" do
      server = server_fixture()
      assert %Ecto.Changeset{} = Remote.change_server(server)
    end
  end

  describe "keys" do
    alias Core.Remote.Key

    @valid_attrs %{key: "some key", private: "some private", public: "some public", title: "some title"}
    @update_attrs %{key: "some updated key", private: "some updated private", public: "some updated public", title: "some updated title"}
    @invalid_attrs %{key: nil, private: nil, public: nil, title: nil}

    def key_fixture(attrs \\ %{}) do
      adapter = adapter_fixture()
      account = account_fixture(%{hosting_adapter_id: adapter.id})
      instance = instance_fixture()
      {:ok, key} =
        attrs
        |> Enum.into(%{instance_id: instance.id, hosting_account_id: account.id})
        |> Enum.into(@valid_attrs)
        |> Remote.create_key()

      key
    end

    test "list_keys/0 returns all keys" do
      key = key_fixture()
      assert Remote.list_keys() == [key]
    end

    test "get_key!/1 returns the key with given id" do
      key = key_fixture()
      assert Remote.get_key!(key.id) == key
    end

    test "create_key/1 with valid data creates a key" do
      adapter = adapter_fixture()
      account = account_fixture(%{hosting_adapter_id: adapter.id})
      instance = instance_fixture()
      assert {:ok, %Key{} = key} = Remote.create_key(Map.merge(@valid_attrs, %{instance_id: instance.id, hosting_account_id: account.id}))
      assert key.key == "some key"
      assert key.private == "some private"
      assert key.public == "some public"
      assert key.title == "some title"
    end

    test "create_key/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Remote.create_key(@invalid_attrs)
    end

    test "generate_key_attrs/1 returns key attrs for create_key/1" do
      assert %{title: "some_title", public: "ssh-rsa " <> _, private: "-----BEGIN RSA PRIVATE KEY-----" <> _} = Remote.generate_key_attrs("some_title")
    end

    test "update_key/2 with valid data updates the key" do
      key = key_fixture()
      assert {:ok, %Key{} = key} = Remote.update_key(key, @update_attrs)
      assert key.key == "some updated key"
      assert key.private == "some updated private"
      assert key.public == "some updated public"
      assert key.title == "some updated title"
    end

    test "update_key/2 with invalid data returns error changeset" do
      key = key_fixture()
      assert {:error, %Ecto.Changeset{}} = Remote.update_key(key, @invalid_attrs)
      assert key == Remote.get_key!(key.id)
    end

    test "delete_key/1 deletes the key" do
      key = key_fixture()
      assert {:ok, %Key{}} = Remote.delete_key(key)
      assert_raise Ecto.NoResultsError, fn -> Remote.get_key!(key.id) end
    end

    test "change_key/1 returns a key changeset" do
      key = key_fixture()
      assert %Ecto.Changeset{} = Remote.change_key(key)
    end
  end
end
