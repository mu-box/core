defmodule App.Repo.Migrations.CreateHostingAccountCredentials do
  use Ecto.Migration

  def change do
    create table(:hosting_account_credentials) do
      add :hosting_account_id, references(:hosting_accounts, on_delete: :delete_all), null: false
      add :hosting_credential_field_id, references(:hosting_credential_fields, on_delete: :nothing), null: false
      add :value, :binary, null: false

      timestamps()
    end

    create index(:hosting_account_credentials, [:hosting_account_id])
    create index(:hosting_account_credentials, [:hosting_credential_field_id])
    create unique_index(:hosting_account_credentials, [:hosting_account_id, :hosting_credential_field_id])
  end
end
