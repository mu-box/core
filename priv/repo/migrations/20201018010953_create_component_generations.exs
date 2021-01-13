defmodule Core.Repo.Migrations.CreateComponentGenerations do
  use Ecto.Migration

  def change do
    create table(:component_generations) do
      add :image, :string
      add :counter, :integer
      add :component_id, references(:components, on_delete: :nothing)

      timestamps()
    end

    create index(:component_generations, [:component_id])
  end
end
