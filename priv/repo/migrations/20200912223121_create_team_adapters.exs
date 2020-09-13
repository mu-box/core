defmodule App.Repo.Migrations.CreateTeamAdapters do
  use Ecto.Migration

  def change do
    create table(:team_adapters) do
      add :team_id, references(:teams, on_delete: :nothing), null: false
      add :hosting_adapter_id, references(:hosting_adapters, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:team_adapters, [:team_id])
    create index(:team_adapters, [:hosting_adapter_id])
    create unique_index(:team_adapters, [:team_id, :hosting_adapter_id])
  end
end
