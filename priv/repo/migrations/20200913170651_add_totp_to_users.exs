defmodule App.Repo.Migrations.AddTotpToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :totp_secret, :binary
      add :last_totp, :string
      add :totp_backup, :json
    end
  end
end
