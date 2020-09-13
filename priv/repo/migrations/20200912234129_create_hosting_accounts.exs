defmodule App.Repo.Migrations.CreateHostingAccounts do
  use Ecto.Migration

  def change do
    create table(:hosting_accounts) do
      add :user_id, references(:users, on_delete: :nothing)
      add :team_id, references(:teams, on_delete: :nothing)
      add :hosting_adapter_id, references(:hosting_adapters, on_delete: :nothing), null: false
      add :name, :string, null: false

      timestamps()
    end

    create index(:hosting_accounts, [:user_id])
    create index(:hosting_accounts, [:team_id])
    create index(:hosting_accounts, [:hosting_adapter_id])
    create unique_index(:hosting_accounts, [:user_id, :team_id, :name])
  end
end
