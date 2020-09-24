defmodule Core.Hosting.TeamAdapter do
  use Core.Schema
  import Ecto.Changeset

  schema "team_adapters" do
    belongs_to :team, Core.Accounts.Team
    belongs_to :hosting_adapter, Core.Hosting.Adapter

    timestamps()
  end

  @doc false
  def changeset(team_adapter, attrs) do
    team_adapter
    |> cast(attrs, [:team_id, :hosting_adapter_id])
    |> validate_required([:team_id, :hosting_adapter_id])
  end
end
