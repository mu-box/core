defmodule App.Accounts.User do
  use App.Schema
  use Pow.Ecto.Schema
  use PowAssent.Ecto.Schema
  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowEmailConfirmation, PowPersistentSession, PowInvitation],
    password_hash_methods: {&Argon2.hash_pwd_salt/1, &Argon2.verify_pass/2}

  schema "users" do
    pow_user_fields()

    field :superuser, :boolean, default: false
    # field :2fa_secret, :string

    has_many :memberships, App.Accounts.TeamMembership
    has_many :teams, through: [:memberships, :team]

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
  end
end
