defmodule Core.Repo.Migrations.CreateServers do
  use Ecto.Migration

  def change do
    create table(:servers) do
      add :instance_id, references(:instances, on_delete: :nothing), null: false
      add :hosting_account_id, references(:hosting_accounts, on_delete: :nothing), null: false
      add :specs_id, references(:hosting_specs, on_delete: :nothing), null: false
      add :server, :string
      add :status, :string
      add :name, :string
      add :external_ip, :string
      add :internal_ip, :string
      add :token, :string

      timestamps()
    end

    create index(:servers, [:instance_id])
    create index(:servers, [:hosting_account_id])
    create index(:servers, [:specs_id])
  end
end
