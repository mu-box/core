defmodule App.Hosting.Credential do
  use App.Schema
  import Ecto.Changeset

  schema "hosting_account_credentials" do
    belongs_to :hosting_account, App.Hosting.Account
    belongs_to :hosting_credential_field, App.Hosting.CredentialField
    field :value, Encryption.EncryptedField

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:hosting_account_id, :hosting_credential_field_id, :value])
    |> validate_required([:hosting_account_id, :hosting_credential_field_id, :value])
  end
end
