defmodule App.Hosting.TeamAdapter do
  use App.Schema
  import Ecto.Changeset

  schema "team_adapters" do
    belongs_to :team, App.Accounts.Team
    belongs_to :hosting_adapter, App.Hosting.Adapter

    timestamps()
  end

  @doc false
  def changeset(team_adapter, attrs) do
    team_adapter
    |> cast(attrs, [])
    |> validate_required([])
  end
end
