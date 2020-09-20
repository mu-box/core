defmodule App.Repo.Migrations.AddTotpToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :authentication_token, :string, null: false, default: ""
    end
  end
end
