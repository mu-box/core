defmodule Core.Components.Generation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "component_generations" do
    field :counter, :integer
    field :image, :string
    field :component_id, :id

    timestamps()
  end

  @doc false
  def changeset(generation, attrs) do
    generation
    |> cast(attrs, [:image, :counter])
    |> validate_required([:image, :counter])
  end
end
