defmodule App.Accounts.TeamMembership do
  use App.Schema
  import Ecto.Changeset

  schema "team_memberships" do
    belongs_to :team, App.Accounts.Team
    belongs_to :user, App.Accounts.User
    belongs_to :role, App.Accounts.Role

    timestamps()
  end

  @doc false
  def changeset(team_membership, attrs) do
    team_membership
    |> cast(attrs, [])
    |> validate_required([])
    |> unique_constraint([:team, :user])
  end
end
