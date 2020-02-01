defmodule App.UserIdentities.UserIdentity do
  use App.Schema
  use PowAssent.Ecto.UserIdentities.Schema, user: App.Accounts.User

  schema "user_identities" do
    pow_assent_user_identity_fields()

    timestamps()
  end
end
