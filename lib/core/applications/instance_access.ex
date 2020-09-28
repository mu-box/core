defmodule Core.Applications.InstanceAccess do
  use Core.Schema
  import Ecto.Changeset

  schema "instance_access" do
    belongs_to :instance, Core.Applications.Instance
    belongs_to :user, Core.Accounts.User
    belongs_to :role, Core.Accounts.Role

    timestamps()
  end

  @doc false
  def changeset(instance_access, attrs) do
    instance_access
    |> cast(attrs, [:instance_id, :user_id, :role_id])
    |> validate_required([:instance_id, :user_id, :role_id])
    |> unique_constraint([:instance_id, :user_id])
    |> foreign_key_constraint(:instances, name: :instance_access_instance_id_fkey)
    |> foreign_key_constraint(:users, name: :instance_access_user_id_fkey)
    |> foreign_key_constraint(:roles, name: :instance_access_role_id_fkey)
  end
end
