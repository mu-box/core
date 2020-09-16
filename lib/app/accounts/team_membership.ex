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
    attrs =
      if Map.has_key?(attrs, "username") do
        case App.Accounts.get_user_by_name(attrs["username"]) do
          nil -> attrs
          user -> Map.put_new(attrs, "user_id", user.id)
        end
      else
        attrs
      end

    changeset =
      team_membership
      |> cast(attrs, [:team_id, :user_id, :role_id])
      |> validate_required([:team_id, :user_id, :role_id])
      |> unique_constraint([:team_id, :user_id])

    case changeset.errors do
      [user_id: _error] -> add_error(changeset, :username, "user not found")
      _else -> changeset
    end
  end
end
