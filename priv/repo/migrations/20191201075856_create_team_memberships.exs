defmodule App.Repo.Migrations.CreateTeamMemberships do
  use Ecto.Migration

  def change do
    create table(:team_memberships) do
      add :team_id, references(:teams, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
      add :team_role_id, references(:team_roles, on_delete: :nothing)

      timestamps()
    end

    create index(:team_memberships, [:team_id])
    create index(:team_memberships, [:user_id])
    create index(:team_memberships, [:team_role_id])
  end
end
