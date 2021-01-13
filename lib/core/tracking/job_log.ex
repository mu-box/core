defmodule Core.Tracking.JobLog do
  use Core.Schema
  import Ecto.Changeset

  schema "job_logs" do
    belongs_to :instance, Core.Applications.Instance
    field :args, :map
    field :attempt, :integer
    field :level, :string
    field :line, :string
    field :worker, :string

    timestamps()
  end

  @doc false
  def changeset(job_log, attrs) do
    job_log
    |> cast(attrs, [:worker, :args, :attempt, :level, :line])
    |> validate_required([:worker, :args, :attempt, :level, :line])
  end
end
