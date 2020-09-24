defmodule Core.Accounts.Role do
  use Core.Schema
  import Ecto.Changeset

  schema "roles" do
    field :name, :string
    field :permissions, :map

    has_many :memberships, Core.Accounts.TeamMembership

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :permissions])
    |> validate_required([:name, :permissions])
  end
end
