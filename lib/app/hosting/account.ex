defmodule App.Hosting.Account do
  use App.Schema
  import Ecto.Changeset

  schema "hosting_accounts" do
    belongs_to :user, App.Accounts.User
    belongs_to :team, App.Accounts.Team
    belongs_to :hosting_adapter, App.Hosting.Adapter
    field :name, :string

    has_many :creds, App.Hosting.Credential, foreign_key: :hosting_account_id

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:user_id, :team_id, :hosting_adapter_id, :name])
    |> validate_required([:hosting_adapter_id, :name])
  end
end
