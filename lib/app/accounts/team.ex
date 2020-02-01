defmodule App.Accounts.Team do
  use App.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string

    has_many :memberships, App.Accounts.TeamMembership
    has_many :users, through: [:memberships, :user]

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
