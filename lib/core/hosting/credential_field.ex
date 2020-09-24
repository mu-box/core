defmodule Core.Hosting.CredentialField do
  use Core.Schema
  import Ecto.Changeset

  schema "hosting_credential_fields" do
    belongs_to :hosting_adapter, Core.Hosting.Adapter
    field :key, :string
    field :label, :string

    timestamps()
  end

  @doc false
  def changeset(credential_field, attrs) do
    credential_field
    |> cast(attrs, [:hosting_adapter_id, :key, :label])
    |> validate_required([:hosting_adapter_id, :key, :label])
  end
end
