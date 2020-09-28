defmodule Core.Repo.Migrations.CreateInstanceAccess do
  use Ecto.Migration

  def change do
    create table(:instance_access) do
      add :instance_id, references(:instances, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
      add :role_id, references(:roles, on_delete: :nothing)

      timestamps()
    end

    create index(:instance_access, [:instance_id])
    create index(:instance_access, [:user_id])
    create index(:instance_access, [:role_id])
    create unique_index(:instance_access, [:instance_id, :user_id])
  end
end
