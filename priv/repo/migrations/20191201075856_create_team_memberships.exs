defmodule App.Repo.Migrations.CreateTeamMemberships do
  use Ecto.Migration

  def change do
    create table(:team_memberships) do
      add :team_id, references(:teams, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :role_id, references(:roles, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:team_memberships, [:team_id, :user_id])
  end
end
