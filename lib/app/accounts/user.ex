defmodule App.Accounts.User do
  use App.Schema
  import Ecto.Changeset
  use Pow.Ecto.Schema,
    user_id_field: :username,
    password_hash_methods: {&Argon2.hash_pwd_salt/1, &Argon2.verify_pass/2},
    password_min_length: 8
  use PowAssent.Ecto.Schema
  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowEmailConfirmation, PowPersistentSession, PowInvitation]

  schema "users" do
    field :email, :string, null: false
    field :superuser, :boolean, default: false
    # 2FA support:
    # field :totp_secret, :string
    # field :last_totp, :string

    pow_user_fields()

    has_many :memberships, App.Accounts.TeamMembership
    has_many :teams, through: [:memberships, :team]
    has_many :hosting_adapters, App.Hosting.Adapter
    has_many :hosting_accounts, App.Hosting.Account

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end
end
