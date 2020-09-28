defmodule Core.Repo.Migrations.CreateInstances do
  use Ecto.Migration

  def change do
    create table(:instances) do
      add :app_id, references(:apps, on_delete: :nothing), null: false
      add :name, :string, default: "default", null: false
      add :timezone, :string, default: "UTC", null: false
      add :state, :string, default: "creating", null: false
      add :auto_reconfigure, :boolean, default: false, null: false
      add :keep_deploys, :integer, default: 2, null: false

      timestamps()
    end

    create index(:instances, [:app_id])
    create unique_index(:instances, [:name, :app_id])
  end
end
