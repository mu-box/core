defmodule Core.Components.Member do
  use Ecto.Schema
  import Ecto.Changeset

  schema "component_members" do
    field :counter, :integer
    field :network, :string
    field :pulse, :string
    field :state, :string
    field :generation_id, :id

    timestamps()
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:counter, :state, :pulse, :network])
    |> validate_required([:counter, :state, :pulse, :network])
  end
end
