defmodule Core.Hosting.Spec do
  use Core.Schema
  import Ecto.Changeset

  schema "hosting_specs" do
    belongs_to :hosting_plan, Core.Hosting.Plan
    field :active, :boolean, default: true
    field :cpu, :decimal
    field :disk, :integer
    field :dollars_per_hr, :decimal
    field :dollars_per_mo, :decimal
    field :ram, :integer
    field :spec, :string
    field :transfer, :integer

    timestamps()
  end

  @doc false
  def changeset(spec, attrs) do
    spec
    |> cast(attrs, [:hosting_plan_id, :spec, :ram, :cpu, :disk, :transfer, :dollars_per_hr, :dollars_per_mo, :active])
    |> validate_required([:hosting_plan_id, :spec, :ram, :cpu, :disk, :transfer, :dollars_per_hr, :dollars_per_mo, :active])
  end
end
