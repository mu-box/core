defmodule App.Repo.Migrations.CreateTeamRoles do
  use Ecto.Migration

  def change do
    create table(:team_roles) do
      add :name, :string

      timestamps()
    end

  end
end
