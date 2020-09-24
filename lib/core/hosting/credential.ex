defmodule Core.Hosting.Credential do
  use Core.Schema
  import Ecto.Changeset

  schema "hosting_account_credentials" do
    belongs_to :hosting_account, Core.Hosting.Account
    belongs_to :hosting_credential_field, Core.Hosting.CredentialField
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
