defmodule Core.Applications.App do
  use Core.Schema
  import Ecto.Changeset

  schema "apps" do
    belongs_to :user, Core.Accounts.User
    belongs_to :team, Core.Accounts.Team
    field :name, :string

    has_many :instances, Core.Applications.Instance

    timestamps()
  end

  @doc false
  def changeset(app, attrs) do
    app
    |> cast(attrs, [:user_id, :team_id, :name])
    |> validate_required([:name])
    |> unique_constraint([:name, :user_id])
    |> unique_constraint([:name, :team_id])
    |> foreign_key_constraint(:instances, name: :instances_app_id_fkey, message: "Must remove all instances to remove an app")
  end
end
