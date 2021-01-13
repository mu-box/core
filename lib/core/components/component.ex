defmodule Core.Components.Component do
  use Ecto.Schema
  import Ecto.Changeset

  schema "components" do
    field :behaviors, {:array, :string}
    field :category, :string
    field :current_generation, :integer
    field :deploy_strategy, :string
    field :horizontal, :boolean, default: false
    field :name, :string
    field :port, :integer
    field :redundant, :boolean, default: false
    field :repair_strategy, :string
    field :uid, :string
    field :instance_id, :id
    field :service_id, :id

    timestamps()
  end

  @doc false
  def changeset(component, attrs) do
    component
    |> cast(attrs, [:name, :uid, :category, :current_generation, :deploy_strategy, :repair_strategy, :behaviors, :port, :horizontal, :redundant])
    |> validate_required([:name, :uid, :category, :current_generation, :deploy_strategy, :repair_strategy, :behaviors, :port, :horizontal, :redundant])
  end
end
