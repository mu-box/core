defmodule App.Repo.Migrations.CreateHostingPlans do
  use Ecto.Migration

  def change do
    create table(:hosting_plans) do
      add :hosting_region_id, references(:hosting_regions, on_delete: :delete_all), null: false
      add :plan, :string, null: false
      add :name, :string, null: false
      add :active, :boolean, default: true, null: false

      timestamps()
    end

    create index(:hosting_plans, [:hosting_region_id])
    create unique_index(:hosting_plans, [:hosting_region_id, :plan])
  end
end
