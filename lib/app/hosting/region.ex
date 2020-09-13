defmodule App.Hosting.Region do
  use App.Schema
  import Ecto.Changeset

  schema "hosting_regions" do
    belongs_to :hosting_adapter, App.Hosting.Adapter
    field :active, :boolean, default: true
    field :name, :string
    field :region, :string

    has_many :plans, App.Hosting.Plan, foreign_key: :hosting_region_id

    timestamps()
  end

  @doc false
  def changeset(region, attrs) do
    region
    |> cast(attrs, [:region, :name, :active])
    |> validate_required([:region, :name, :active])
  end
end
