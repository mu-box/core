defmodule Core.Applications.Service do
  use Ecto.Schema
  import Ecto.Changeset

  schema "services" do
    field :ip, :string
    field :mode, :string
    field :name, :string
    field :slug, :string
    field :token, :string
    field :uid, :string
    field :url, :string
    field :instance_id, :id

    timestamps()
  end

  @doc false
  def changeset(service, attrs) do
    service
    |> cast(attrs, [:uid, :name, :slug, :ip, :url, :mode, :token])
    |> validate_required([:uid, :name, :slug, :ip, :url, :mode, :token])
  end
end
