defmodule Core.Repo.Migrations.CreateJobLogs do
  use Ecto.Migration

  def change do
    create table(:job_logs) do
      add :instance_id, references(:instances, on_delete: :delete_all)
      add :worker, :string
      add :args, :map
      add :attempt, :integer
      add :level, :string
      add :line, :string

      timestamps()
    end

    create index(:job_logs, [:instance_id])
  end
end
