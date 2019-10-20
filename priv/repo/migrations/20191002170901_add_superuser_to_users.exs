defmodule App.Repo.Migrations.AddSuperuserToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :superuser, :boolean, null: false, default: false
    end
  end
end
