defmodule Core.Hosting.Region do
  use Core.Schema
  import Ecto.Changeset

  schema "hosting_regions" do
    belongs_to :hosting_adapter, Core.Hosting.Adapter
    field :active, :boolean, default: true
    field :name, :string
    field :region, :string

    has_many :plans, Core.Hosting.Plan, foreign_key: :hosting_region_id

    timestamps()
  end

  @doc false
  def changeset(region, attrs) do
    region
    |> cast(attrs, [:hosting_adapter_id, :region, :name, :active])
    |> validate_required([:hosting_adapter_id, :region, :name, :active])
  end
end
