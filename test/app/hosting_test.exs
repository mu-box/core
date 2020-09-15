defmodule App.HostingTest do
  use App.DataCase

  alias App.Hosting

  describe "adapters" do
    alias App.Hosting.Adapter

    @valid_attrs %{
      api: "some api",
      bootstrap_script: "some bootstrap_script",
      can_reboot: true,
      can_rename: true,
      default_region: "some default_region",
      default_size: "some default_size",
      endpoint: "some endpoint",
      external_iface: "some external_iface",
      global: true,
      instructions: "some instructions",
      internal_iface: "some internal_iface",
      name: "some name",
      server_nick_name: "some server_nick_name",
      ssh_auth_method: "some ssh_auth_method",
      ssh_key_method: "some ssh_key_method",
      ssh_user: "some ssh_user",
      unlink_code: "some unlink_code"
    }
    @update_attrs %{
      api: "some updated api",
      bootstrap_script: "some updated bootstrap_script",
      can_reboot: false,
      can_rename: false,
      default_region: "some updated default_region",
      default_size: "some updated default_size",
      endpoint: "some updated endpoint",
      external_iface: "some updated external_iface",
      global: false,
      instructions: "some updated instructions",
      internal_iface: "some updated internal_iface",
      name: "some updated name",
      server_nick_name: "some updated server_nick_name",
      ssh_auth_method: "some updated ssh_auth_method",
      ssh_key_method: "some updated ssh_key_method",
      ssh_user: "some updated ssh_user",
      unlink_code: "some updated unlink_code"
    }
    @invalid_attrs %{
      api: nil,
      bootstrap_script: nil,
      can_reboot: nil,
      can_rename: nil,
      default_region: nil,
      default_size: nil,
      endpoint: nil,
      external_iface: nil,
      global: nil,
      instructions: nil,
      internal_iface: nil,
      name: nil,
      server_nick_name: nil,
      ssh_auth_method: nil,
      ssh_key_method: nil,
      ssh_user: nil,
      unlink_code: nil
    }

    def adapter_fixture(attrs \\ %{}) do
      {:ok, adapter} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Hosting.create_adapter()

      adapter
    end

    test "list_adapters/0 returns all adapters" do
      adapter = adapter_fixture()
      assert Hosting.list_adapters() == [adapter]
    end

    test "get_adapter!/1 returns the adapter with given id" do
      adapter = adapter_fixture()
      assert Hosting.get_adapter!(adapter.id) == adapter
    end

    test "create_adapter/1 with valid data creates a adapter" do
      assert {:ok, %Adapter{} = adapter} = Hosting.create_adapter(@valid_attrs)
      assert adapter.api == "some api"
      assert adapter.bootstrap_script == "some bootstrap_script"
      assert adapter.can_reboot == true
      assert adapter.can_rename == true
      assert adapter.default_region == "some default_region"
      assert adapter.default_size == "some default_size"
      assert adapter.endpoint == "some endpoint"
      assert adapter.external_iface == "some external_iface"
      assert adapter.global == true
      assert adapter.instructions == "some instructions"
      assert adapter.internal_iface == "some internal_iface"
      assert adapter.name == "some name"
      assert adapter.server_nick_name == "some server_nick_name"
      assert adapter.ssh_auth_method == "some ssh_auth_method"
      assert adapter.ssh_key_method == "some ssh_key_method"
      assert adapter.ssh_user == "some ssh_user"
      assert adapter.unlink_code == "some unlink_code"
    end

    test "create_adapter/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Hosting.create_adapter(@invalid_attrs)
    end

    test "update_adapter/2 with valid data updates the adapter" do
      adapter = adapter_fixture()
      assert {:ok, %Adapter{} = adapter} = Hosting.update_adapter(adapter, @update_attrs)
      assert adapter.api == "some updated api"
      assert adapter.bootstrap_script == "some updated bootstrap_script"
      assert adapter.can_reboot == false
      assert adapter.can_rename == false
      assert adapter.default_region == "some updated default_region"
      assert adapter.default_size == "some updated default_size"
      assert adapter.endpoint == "some updated endpoint"
      assert adapter.external_iface == "some updated external_iface"
      assert adapter.global == false
      assert adapter.instructions == "some updated instructions"
      assert adapter.internal_iface == "some updated internal_iface"
      assert adapter.name == "some updated name"
      assert adapter.server_nick_name == "some updated server_nick_name"
      assert adapter.ssh_auth_method == "some updated ssh_auth_method"
      assert adapter.ssh_key_method == "some updated ssh_key_method"
      assert adapter.ssh_user == "some updated ssh_user"
      assert adapter.unlink_code == "some updated unlink_code"
    end

    test "update_adapter/2 with invalid data returns error changeset" do
      adapter = adapter_fixture()
      assert {:error, %Ecto.Changeset{}} = Hosting.update_adapter(adapter, @invalid_attrs)
      assert adapter == Hosting.get_adapter!(adapter.id)
    end

    test "delete_adapter/1 deletes the adapter" do
      adapter = adapter_fixture()
      assert {:ok, %Adapter{}} = Hosting.delete_adapter(adapter)
      assert_raise Ecto.NoResultsError, fn -> Hosting.get_adapter!(adapter.id) end
    end

    test "change_adapter/1 returns a adapter changeset" do
      adapter = adapter_fixture()
      assert %Ecto.Changeset{} = Hosting.change_adapter(adapter)
    end
  end
end
