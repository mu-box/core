defmodule Core.Remote.Server do
  use Core.Schema
  import Ecto.Changeset

  schema "servers" do
    belongs_to :instance, Core.Applications.Instance
    belongs_to :hosting_account, Core.Hosting.Account
    belongs_to :specs, Core.Hosting.Spec
    field :external_ip, :string
    field :internal_ip, :string
    field :name, :string
    field :server, :string
    field :status, :string
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(server, attrs) do
    server
    |> cast(attrs, [:instance_id, :hosting_account_id, :specs_id, :server, :status, :name, :external_ip, :internal_ip, :token])
    |> validate_required([:instance_id, :hosting_account_id, :specs_id, :server, :status, :name])
  end
end
