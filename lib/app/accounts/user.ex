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
  alias Encryption.EncryptedField

  schema "users" do
    field :email, :string, null: false
    field :superuser, :boolean, default: false
    # 2FA support:
    field :totp_secret, EncryptedField
    field :last_totp, :string
    field :totp_backup, {:array, :string}

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

  def last_totp_changeset(user, attrs) do
    user
    |> cast(attrs, [:last_totp])
    |> validate_required([:last_totp])
  end

  def totp_changeset(user, attrs) do
    user
    |> cast(attrs, [:totp_secret])
    |> put_change(:totp_backup, attrs["totp_backup"] |> Enum.map(fn code ->
      case String.contains?(code, "$argon2id$") do
        true -> code
        false -> Argon2.hash_pwd_salt code
      end
    end))
    |> validate_required([])
  end

  def add_totp_secret(user) do
    user
    |> cast(%{}, [])
    |> put_change(:totp_secret, Elixir2fa.random_secret())
    |> put_change(:totp_backup,
      Stream.repeatedly(fn -> :rand.uniform(9999999999) end)
      |> Stream.uniq
      |> Enum.take(10)
      |> Enum.map(fn num -> num |> Integer.to_string |> String.pad_leading(10, "0") end)
    )
  end

  def valid_totp?(user, params) do
    totp = params["totp"]
    secret = if Map.has_key?(user, :changes) and Map.has_key?(user.changes, :totp_secret) do
      user.changes.totp_secret
    else
      user.totp_secret
    end
    backup = if Map.has_key?(user, :changes) and Map.has_key?(user.changes, :totp_backup) do
      user.changes.totp_backup
    else
      user.totp_backup
    end
    last = if Map.has_key?(user, :last_totp) do
      user.last_totp
    else
      nil
    end

    case Elixir2fa.generate_totp(secret) do
      ^totp ->
        case last do
          ^totp -> false
          _else -> true
        end
      _else ->
        case Enum.find_index(backup, fn hash -> Argon2.verify_pass(totp, hash) end) do
          nil -> false
          index ->
            user
            |> totp_changeset(%{"totp_backup" => List.delete_at(backup, index)})
            |> App.Repo.update()
            true
        end
    end
  end
end
