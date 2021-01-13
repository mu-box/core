defmodule Core.Components.Server do
  use Ecto.Schema
  import Ecto.Changeset

  schema "component_servers" do
    field :member_id, :id
    field :server_id, :id

    timestamps()
  end

  @doc false
  def changeset(server, attrs) do
    server
    |> cast(attrs, [])
    |> validate_required([])
  end
end
