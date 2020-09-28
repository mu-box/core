defmodule Core.Applications.Instance do
  use Core.Schema
  import Ecto.Changeset

  schema "instances" do
    belongs_to :app, Core.Applications.App
    field :name, :string, default: "default"
    field :state, :string, default: "creating"
    field :timezone, :string, default: "UTC"
    field :auto_reconfigure, :boolean, default: false
    field :keep_deploys, :integer, default: 2

    has_many :access, Core.Applications.InstanceAccess
    has_many :users, through: [:access, :user]

    timestamps()
  end

  @doc false
  def changeset(instance, attrs) do
    instance
    |> cast(attrs, [:app_id, :name, :timezone, :state, :auto_reconfigure, :keep_deploys])
    |> validate_required([:app_id, :name, :timezone, :state, :auto_reconfigure, :keep_deploys])
    |> foreign_key_constraint(:apps, name: :instances_app_id_fkey)
    |> unique_constraint([:name, :app_id])
  end
end
