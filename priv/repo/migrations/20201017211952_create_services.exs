defmodule Core.Repo.Migrations.CreateServices do
  use Ecto.Migration

  def change do
    create table(:services) do
      add :uid, :string
      add :name, :string
      add :slug, :string
      add :ip, :string
      add :url, :string
      add :mode, :string
      add :token, :string
      add :instance_id, references(:instances, on_delete: :nothing)

      timestamps()
    end

    create index(:services, [:instance_id])
  end
end
