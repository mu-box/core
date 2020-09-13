defmodule App.Repo.Migrations.CreateHostingRegions do
  use Ecto.Migration

  def change do
    create table(:hosting_regions) do
      add :hosting_adapter_id, references(:hosting_adapters, on_delete: :nothing), null: false
      add :region, :string, null: false
      add :name, :string, null: false
      add :active, :boolean, default: true, null: false

      timestamps()
    end

    create index(:hosting_regions, [:hosting_adapter_id])
    create unique_index(:hosting_regions, [:hosting_adapter_id, :region])
  end
end
