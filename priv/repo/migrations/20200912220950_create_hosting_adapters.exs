defmodule App.Repo.Migrations.CreateHostingAdapters do
  use Ecto.Migration

  def change do
    create table(:hosting_adapters) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :global, :boolean, default: false, null: false
      add :endpoint, :string
      add :unlink_code, :string
      add :api, :string
      add :name, :string
      add :server_nick_name, :string
      add :default_region, :string
      add :default_size, :string
      add :can_reboot, :boolean
      add :can_rename, :boolean
      add :internal_iface, :string
      add :external_iface, :string
      add :ssh_user, :string
      add :ssh_auth_method, :string
      add :ssh_key_method, :string
      add :bootstrap_script, :string
      add :instructions, :text

      timestamps()
    end

    create index(:hosting_adapters, [:user_id])
  end
end
