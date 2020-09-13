defmodule App.Repo.Migrations.CreateHostingSpecs do
  use Ecto.Migration

  def change do
    create table(:hosting_specs) do
      add :hosting_plan_id, references(:hosting_plans, on_delete: :nothing), null: false
      add :spec, :string, null: false
      add :ram, :integer, null: false
      add :cpu, :integer, null: false
      add :disk, :integer, null: false
      add :transfer, :integer, null: false
      add :dollars_per_hr, :decimal, null: false
      add :dollars_per_mo, :decimal, null: false
      add :active, :boolean, default: true, null: false

      timestamps()
    end

    create index(:hosting_specs, [:hosting_plan_id])
    create unique_index(:hosting_specs, [:hosting_plan_id, :spec])
  end
end
