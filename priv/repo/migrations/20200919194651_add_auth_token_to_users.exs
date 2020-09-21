defmodule App.Repo.Migrations.AddAuthTokenToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :authentication_token, :string, null: false, default: ""
    end
  end
end
