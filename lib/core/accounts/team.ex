defmodule Core.Accounts.Team do
  use Core.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :slug, :string

    has_many :memberships, Core.Accounts.TeamMembership
    has_many :users, through: [:memberships, :user]
    many_to_many :hosting_adapters, Core.Hosting.Adapter,
      join_through: Core.Hosting.TeamAdapter,
      join_keys: [team_id: :id, hosting_adapter_id: :id]
    has_many :hosting_accounts, Core.Hosting.Account
    has_many :apps, Core.Applications.App

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
    |> unique_constraint([:slug])
  end
end
