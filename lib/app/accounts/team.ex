defmodule App.Accounts.Team do
  use App.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :slug, :string

    has_many :memberships, App.Accounts.TeamMembership
    has_many :users, through: [:memberships, :user]
    many_to_many :hosting_adapters, App.Hosting.Adapter, join_through: App.Hosting.TeamAdapter
    has_many :hosting_accounts, App.Hosting.Account

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name, :slug])
  end
end
