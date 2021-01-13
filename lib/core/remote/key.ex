defmodule Core.Remote.Key do
  use Core.Schema
  import Ecto.Changeset

  schema "keys" do
    belongs_to :instance, Core.Applications.Instance
    belongs_to :hosting_account, Core.Hosting.Account
    field :key, :string
    field :title, :string
    field :public, :string
    field :private, Encryption.EncryptedField

    timestamps()
  end

  @doc false
  def changeset(key, attrs) do
    key
    |> cast(attrs, [:instance_id, :hosting_account_id, :key, :title, :public, :private])
    |> validate_required([:instance_id, :hosting_account_id, :title, :public, :private])
  end
end
