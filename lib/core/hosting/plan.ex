defmodule Core.Hosting.Plan do
  use Core.Schema
  import Ecto.Changeset

  schema "hosting_plans" do
    belongs_to :hosting_region, Core.Hosting.Region
    field :active, :boolean, default: true
    field :name, :string
    field :plan, :string

    has_many :specs, Core.Hosting.Spec, foreign_key: :hosting_plan_id

    timestamps()
  end

  @doc false
  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [:hosting_region_id, :plan, :name, :active])
    |> validate_required([:hosting_region_id, :plan, :name, :active])
  end
end
