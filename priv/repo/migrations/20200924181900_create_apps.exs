defmodule Core.Repo.Migrations.CreateApps do
  use Ecto.Migration

  def change do
    create table(:apps) do
      add :user_id, references(:users, on_delete: :nothing)
      add :team_id, references(:teams, on_delete: :nothing)
      add :name, :string

      timestamps()
    end

    create index(:apps, [:user_id])
    create index(:apps, [:team_id])
    create unique_index(:apps, [:name, :user_id])
    create unique_index(:apps, [:name, :team_id])
  end
end
