defmodule Core.Repo.Migrations.CreateComponentServers do
  use Ecto.Migration

  def change do
    create table(:component_servers) do
      add :member_id, references(:component_members, on_delete: :nothing)
      add :server_id, references(:servers, on_delete: :nothing)

      timestamps()
    end

    create index(:component_servers, [:member_id])
    create index(:component_servers, [:server_id])
  end
end
