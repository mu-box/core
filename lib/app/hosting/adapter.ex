defmodule App.Hosting.Adapter do
  use App.Schema
  import Ecto.Changeset

  schema "hosting_adapters" do
    belongs_to :user, App.Accounts.User
    field :api, :string
    field :bootstrap_script, :string
    field :can_reboot, :boolean
    field :can_rename, :boolean
    field :default_region, :string
    field :default_size, :string
    field :endpoint, :string
    field :external_iface, :string
    field :global, :boolean, default: false
    field :instructions, :string
    field :internal_iface, :string
    field :name, :string
    field :server_nick_name, :string
    field :ssh_auth_method, :string
    field :ssh_key_method, :string
    field :ssh_user, :string
    field :unlink_code, :string

    many_to_many :teams, App.Accounts.Team, join_through: App.Hosting.TeamAdapter
    has_many :regions, App.Hosting.Region, foreign_key: :hosting_adapter_id

    timestamps()
  end

  @doc false
  def changeset(adapter, attrs) do
    adapter
    |> cast(attrs, [:user_id, :global, :endpoint, :unlink_code, :api, :name, :server_nick_name, :default_region, :default_size, :can_reboot, :can_rename, :internal_iface, :external_iface, :ssh_user, :ssh_auth_method, :ssh_key_method, :bootstrap_script, :instructions])
    |> validate_required([:user_id])
  end
end
