defmodule Core.Repo.Migrations.CreateComponentMembers do
  use Ecto.Migration

  def change do
    create table(:component_members) do
      add :counter, :integer
      add :state, :string
      add :pulse, :string
      add :network, :string
      add :generation_id, references(:component_generations, on_delete: :nothing)

      timestamps()
    end

    create index(:component_members, [:generation_id])
  end
end
