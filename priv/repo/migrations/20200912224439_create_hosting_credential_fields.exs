defmodule App.Repo.Migrations.CreateHostingCredentialFields do
  use Ecto.Migration

  def change do
    create table(:hosting_credential_fields) do
      add :hosting_adapter_id, references(:hosting_adapters, on_delete: :nothing), null: false
      add :key, :string, null: false
      add :label, :string, null: false

      timestamps()
    end

    create index(:hosting_credential_fields, [:hosting_adapter_id])
    create unique_index(:hosting_credential_fields, [:hosting_adapter_id, :key])
  end
end
