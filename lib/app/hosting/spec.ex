defmodule App.Hosting.Spec do
  use App.Schema
  import Ecto.Changeset

  schema "hosting_specs" do
    belongs_to :hosting_plan, App.Hosting.Plan
    field :active, :boolean, default: true
    field :cpu, :integer
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
    |> cast(attrs, [:spec, :ram, :cpu, :disk, :transfer, :dollars_per_hr, :dollars_per_mo, :active])
    |> validate_required([:spec, :ram, :cpu, :disk, :transfer, :dollars_per_hr, :dollars_per_mo, :active])
  end
end