defmodule App.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :slug, :string

      timestamps()
    end

    create unique_index(:teams, [:slug])
  end
end
