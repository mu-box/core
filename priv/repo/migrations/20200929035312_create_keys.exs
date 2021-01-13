defmodule Core.Repo.Migrations.CreateKeys do
  use Ecto.Migration

  def change do
    create table(:keys) do
      add :instance_id, references(:instances, on_delete: :nothing), null: false
      add :hosting_account_id, references(:hosting_accounts, on_delete: :nothing), null: false
      add :key, :string
      add :title, :string
      add :public, :string
      add :private, :binary

      timestamps()
    end

    create index(:keys, [:instance_id])
  end
end
