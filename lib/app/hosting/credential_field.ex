defmodule App.Hosting.CredentialField do
  use App.Schema
  import Ecto.Changeset

  schema "hosting_credential_fields" do
    belongs_to :hosting_adapter, App.Hosting.Adapter
    field :key, :string
    field :label, :string

    timestamps()
  end

  @doc false
  def changeset(credential_field, attrs) do
    credential_field
    |> cast(attrs, [:key, :label])
    |> validate_required([:key, :label])
  end
end
