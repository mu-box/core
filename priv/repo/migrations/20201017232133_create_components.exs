defmodule Core.Repo.Migrations.CreateComponents do
  use Ecto.Migration

  def change do
    create table(:components) do
      add :name, :string
      add :uid, :string
      add :category, :string
      add :current_generation, :integer
      add :deploy_strategy, :string
      add :repair_strategy, :string
      add :behaviors, {:array, :string}
      add :port, :integer
      add :horizontal, :boolean, default: false, null: false
      add :redundant, :boolean, default: false, null: false
      add :instance_id, references(:instances, on_delete: :nothing)
      add :service_id, references(:services, on_delete: :nothing)

      timestamps()
    end

    create index(:components, [:instance_id])
    create index(:components, [:service_id])
  end
end
