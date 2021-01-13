defmodule Core.ComponentsTest do
  use Core.DataCase

  alias Core.Components

  describe "components" do
    alias Core.Components.Component

    @valid_attrs %{behaviors: [], category: "some category", current_generation: 42, deploy_strategy: "some deploy_strategy", horizontal: true, name: "some name", port: 42, redundant: true, repair_strategy: "some repair_strategy", uid: "some uid"}
    @update_attrs %{behaviors: [], category: "some updated category", current_generation: 43, deploy_strategy: "some updated deploy_strategy", horizontal: false, name: "some updated name", port: 43, redundant: false, repair_strategy: "some updated repair_strategy", uid: "some updated uid"}
    @invalid_attrs %{behaviors: nil, category: nil, current_generation: nil, deploy_strategy: nil, horizontal: nil, name: nil, port: nil, redundant: nil, repair_strategy: nil, uid: nil}

    def component_fixture(attrs \\ %{}) do
      {:ok, component} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Components.create_component()

      component
    end

    test "list_components/0 returns all components" do
      component = component_fixture()
      assert Components.list_components() == [component]
    end

    test "get_component!/1 returns the component with given id" do
      component = component_fixture()
      assert Components.get_component!(component.id) == component
    end

    test "create_component/1 with valid data creates a component" do
      assert {:ok, %Component{} = component} = Components.create_component(@valid_attrs)
      assert component.behaviors == []
      assert component.category == "some category"
      assert component.current_generation == 42
      assert component.deploy_strategy == "some deploy_strategy"
      assert component.horizontal == true
      assert component.name == "some name"
      assert component.port == 42
      assert component.redundant == true
      assert component.repair_strategy == "some repair_strategy"
      assert component.uid == "some uid"
    end

    test "create_component/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Components.create_component(@invalid_attrs)
    end

    test "update_component/2 with valid data updates the component" do
      component = component_fixture()
      assert {:ok, %Component{} = component} = Components.update_component(component, @update_attrs)
      assert component.behaviors == []
      assert component.category == "some updated category"
      assert component.current_generation == 43
      assert component.deploy_strategy == "some updated deploy_strategy"
      assert component.horizontal == false
      assert component.name == "some updated name"
      assert component.port == 43
      assert component.redundant == false
      assert component.repair_strategy == "some updated repair_strategy"
      assert component.uid == "some updated uid"
    end

    test "update_component/2 with invalid data returns error changeset" do
      component = component_fixture()
      assert {:error, %Ecto.Changeset{}} = Components.update_component(component, @invalid_attrs)
      assert component == Components.get_component!(component.id)
    end

    test "delete_component/1 deletes the component" do
      component = component_fixture()
      assert {:ok, %Component{}} = Components.delete_component(component)
      assert_raise Ecto.NoResultsError, fn -> Components.get_component!(component.id) end
    end

    test "change_component/1 returns a component changeset" do
      component = component_fixture()
      assert %Ecto.Changeset{} = Components.change_component(component)
    end
  end

  describe "component_generations" do
    alias Core.Components.Generation

    @valid_attrs %{counter: 42, image: "some image"}
    @update_attrs %{counter: 43, image: "some updated image"}
    @invalid_attrs %{counter: nil, image: nil}

    def generation_fixture(attrs \\ %{}) do
      {:ok, generation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Components.create_generation()

      generation
    end

    test "list_component_generations/0 returns all component_generations" do
      generation = generation_fixture()
      assert Components.list_component_generations() == [generation]
    end

    test "get_generation!/1 returns the generation with given id" do
      generation = generation_fixture()
      assert Components.get_generation!(generation.id) == generation
    end

    test "create_generation/1 with valid data creates a generation" do
      assert {:ok, %Generation{} = generation} = Components.create_generation(@valid_attrs)
      assert generation.counter == 42
      assert generation.image == "some image"
    end

    test "create_generation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Components.create_generation(@invalid_attrs)
    end

    test "update_generation/2 with valid data updates the generation" do
      generation = generation_fixture()
      assert {:ok, %Generation{} = generation} = Components.update_generation(generation, @update_attrs)
      assert generation.counter == 43
      assert generation.image == "some updated image"
    end

    test "update_generation/2 with invalid data returns error changeset" do
      generation = generation_fixture()
      assert {:error, %Ecto.Changeset{}} = Components.update_generation(generation, @invalid_attrs)
      assert generation == Components.get_generation!(generation.id)
    end

    test "delete_generation/1 deletes the generation" do
      generation = generation_fixture()
      assert {:ok, %Generation{}} = Components.delete_generation(generation)
      assert_raise Ecto.NoResultsError, fn -> Components.get_generation!(generation.id) end
    end

    test "change_generation/1 returns a generation changeset" do
      generation = generation_fixture()
      assert %Ecto.Changeset{} = Components.change_generation(generation)
    end
  end

  describe "component_members" do
    alias Core.Components.Member

    @valid_attrs %{counter: 42, network: "some network", pulse: "some pulse", state: "some state"}
    @update_attrs %{counter: 43, network: "some updated network", pulse: "some updated pulse", state: "some updated state"}
    @invalid_attrs %{counter: nil, network: nil, pulse: nil, state: nil}

    def member_fixture(attrs \\ %{}) do
      {:ok, member} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Components.create_member()

      member
    end

    test "list_component_members/0 returns all component_members" do
      member = member_fixture()
      assert Components.list_component_members() == [member]
    end

    test "get_member!/1 returns the member with given id" do
      member = member_fixture()
      assert Components.get_member!(member.id) == member
    end

    test "create_member/1 with valid data creates a member" do
      assert {:ok, %Member{} = member} = Components.create_member(@valid_attrs)
      assert member.counter == 42
      assert member.network == "some network"
      assert member.pulse == "some pulse"
      assert member.state == "some state"
    end

    test "create_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Components.create_member(@invalid_attrs)
    end

    test "update_member/2 with valid data updates the member" do
      member = member_fixture()
      assert {:ok, %Member{} = member} = Components.update_member(member, @update_attrs)
      assert member.counter == 43
      assert member.network == "some updated network"
      assert member.pulse == "some updated pulse"
      assert member.state == "some updated state"
    end

    test "update_member/2 with invalid data returns error changeset" do
      member = member_fixture()
      assert {:error, %Ecto.Changeset{}} = Components.update_member(member, @invalid_attrs)
      assert member == Components.get_member!(member.id)
    end

    test "delete_member/1 deletes the member" do
      member = member_fixture()
      assert {:ok, %Member{}} = Components.delete_member(member)
      assert_raise Ecto.NoResultsError, fn -> Components.get_member!(member.id) end
    end

    test "change_member/1 returns a member changeset" do
      member = member_fixture()
      assert %Ecto.Changeset{} = Components.change_member(member)
    end
  end

  describe "component_servers" do
    alias Core.Components.Server

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def server_fixture(attrs \\ %{}) do
      {:ok, server} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Components.create_server()

      server
    end

    test "list_component_servers/0 returns all component_servers" do
      server = server_fixture()
      assert Components.list_component_servers() == [server]
    end

    test "get_server!/1 returns the server with given id" do
      server = server_fixture()
      assert Components.get_server!(server.id) == server
    end

    test "create_server/1 with valid data creates a server" do
      assert {:ok, %Server{} = server} = Components.create_server(@valid_attrs)
    end

    test "create_server/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Components.create_server(@invalid_attrs)
    end

    test "update_server/2 with valid data updates the server" do
      server = server_fixture()
      assert {:ok, %Server{} = server} = Components.update_server(server, @update_attrs)
    end

    test "update_server/2 with invalid data returns error changeset" do
      server = server_fixture()
      assert {:error, %Ecto.Changeset{}} = Components.update_server(server, @invalid_attrs)
      assert server == Components.get_server!(server.id)
    end

    test "delete_server/1 deletes the server" do
      server = server_fixture()
      assert {:ok, %Server{}} = Components.delete_server(server)
      assert_raise Ecto.NoResultsError, fn -> Components.get_server!(server.id) end
    end

    test "change_server/1 returns a server changeset" do
      server = server_fixture()
      assert %Ecto.Changeset{} = Components.change_server(server)
    end
  end
end
