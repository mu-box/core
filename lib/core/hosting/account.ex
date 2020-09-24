defmodule Core.Hosting.Account do
  use Core.Schema
  import Ecto.Changeset

  schema "hosting_accounts" do
    belongs_to :user, Core.Accounts.User
    belongs_to :team, Core.Accounts.Team
    belongs_to :hosting_adapter, Core.Hosting.Adapter
    field :name, :string

    has_many :creds, Core.Hosting.Credential, foreign_key: :hosting_account_id

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:user_id, :team_id, :hosting_adapter_id, :name])
    |> validate_required([:hosting_adapter_id, :name])
  end
end
