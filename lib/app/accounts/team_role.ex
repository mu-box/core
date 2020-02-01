defmodule App.Accounts.TeamRole do
  use App.Schema
  import Ecto.Changeset

  schema "team_roles" do
    field :name, :string

    has_many :memberships, App.Accounts.TeamMembership

    timestamps()
  end

  @doc false
  def changeset(team_role, attrs) do
    team_role
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
