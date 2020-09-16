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
    team = team
    |> cast(attrs, [:name])
    |> validate_required([:name])

    if Map.has_key?(team.changes, :name) do
      team.changes.name
    else
      team.data.name
    end
    |> case do
      nil ->
        team
      name ->
        team
        |> put_change(:slug, Slug.slugify(name))
    end
  end
end
