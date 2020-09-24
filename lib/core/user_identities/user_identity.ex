defmodule Core.UserIdentities.UserIdentity do
  use Core.Schema
  use PowAssent.Ecto.UserIdentities.Schema, user: Core.Accounts.User

  schema "user_identities" do
    pow_assent_user_identity_fields()

    timestamps()
  end
end
