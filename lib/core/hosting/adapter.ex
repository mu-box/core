defmodule Core.Hosting.Adapter do
  use Core.Schema
  import Ecto.Changeset

  require Logger

  schema "hosting_adapters" do
    belongs_to :user, Core.Accounts.User
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

    many_to_many :teams, Core.Accounts.Team, join_through: Core.Hosting.TeamAdapter, join_keys: [hosting_adapter_id: :id, team_id: :id]
    has_many :fields, Core.Hosting.CredentialField, foreign_key: :hosting_adapter_id
    has_many :regions, Core.Hosting.Region, foreign_key: :hosting_adapter_id

    timestamps()
  end

  @doc false
  def changeset(adapter, attrs) do
    adapter
    |> cast(attrs, [:user_id, :global, :endpoint, :unlink_code, :api, :name, :server_nick_name, :default_region, :default_size, :can_reboot, :can_rename, :internal_iface, :external_iface, :ssh_user, :ssh_auth_method, :ssh_key_method, :bootstrap_script, :instructions])
    |> validate_required([:user_id])
    |> foreign_key_constraint(:hosting_credential_fields, name: :hosting_credential_fields_hosting_adapter_id_fkey, message: "Can't delete with child properties")
    |> foreign_key_constraint(:hosting_regions, name: :hosting_regions_hosting_adapter_id_fkey, message: "Can't delete with child properties")
  end

  def generate_unlink_code() do
    :crypto.strong_rand_bytes(30)
    |> Base.url_encode64(padding: false)
  end

  def populate_config(adapter) do
    if adapter.endpoint do
      # First, mark anything we already have in the system as inactive
      adapter = adapter |> Core.Repo.preload([:regions])
      Enum.each(adapter.regions, fn (region) ->
        region = region |> Core.Repo.preload([:plans])
        Enum.each(region.plans, fn (plan) ->
          plan = plan |> Core.Repo.preload([:specs])
          Enum.each(plan.specs, fn (spec) ->
            spec
            |> Core.Hosting.Spec.changeset(%{active: false})
            |> Core.Repo.update()
          end)
          plan
          |> Core.Hosting.Plan.changeset(%{active: false})
          |> Core.Repo.update()
        end)
        region
        |> Core.Hosting.Region.changeset(%{active: false})
        |> Core.Repo.update()
      end)

      # Now, update the adapter with the meta data
      case HTTPoison.get(adapter.endpoint <> "/meta") do
        {:ok, response} ->
          response.body
          |> Poison.decode!()
          |> populate_meta(adapter)
        {:error, err} ->
          Logger.error(adapter.endpoint <> "/meta: " <> Atom.to_string(err.reason))
          false
      end
      |> if do
        # Finally, update the catalog, forcing current options to active again
        case HTTPoison.get(adapter.endpoint <> "/catalog", [], recv_timeout: 120_000) do
          {:ok, response} ->
            response.body
            |> Poison.decode!()
            |> populate_catalog(adapter)
          {:error, err} ->
            Logger.error(adapter.endpoint <> "/catalog: " <> Atom.to_string(err.reason))
            {:error, err}
        end
      else
        {:error, "Populating adapter metadata failed. See log for more details."}
      end
    end
  end

  defp populate_meta(meta, adapter) do
    meta_id = meta["id"]
    case adapter.api do
      nil -> true
      ^meta_id -> true
      _else -> false
    end
    |> if do
      changeset(adapter, %{
        api: meta["id"],
        name: meta["name"],
        server_nick_name: meta["server_nick_name"],
        default_region: meta["default_region"],
        default_size: meta["default_size"],
        can_reboot: meta["can_reboot"],
        can_rename: meta["can_rename"],
        internal_iface: meta["internal_iface"],
        external_iface: meta["external_iface"],
        ssh_user: meta["ssh_user"],
        ssh_auth_method: meta["ssh_auth_method"],
        ssh_key_method: meta["ssh_key_method"],
        bootstrap_script: meta["bootstrap_script"],
        instructions: meta["instructions"],
      })
      |> Core.Repo.update()

      Enum.each(meta["credential_fields"], fn (field_data) ->
        field = Core.Repo.get_by(Core.Hosting.CredentialField, [hosting_adapter_id: adapter.id, key: field_data["key"]]) || %Core.Hosting.CredentialField{}
        Core.Hosting.CredentialField.changeset(field, %{
          hosting_adapter_id: adapter.id,
          key: field_data["key"],
          label: field_data["label"],
        })
        |> Core.Repo.insert_or_update()
      end)
      true
    else
      false
    end
  end

  defp populate_catalog(regions, adapter) do
    case regions do
      %{"errors" => errors} ->
        Logger.error(adapter.endpoint <> "/catalog (JSON): " <> Enum.join(errors, " // "))
        {:error, errors}
      regions ->
        Enum.each(regions, fn (region_data) ->
          region = Core.Repo.get_by(Core.Hosting.Region, [hosting_adapter_id: adapter.id, region: region_data["id"]]) || %Core.Hosting.Region{}
          {:ok, db_region} = Core.Hosting.Region.changeset(region, %{
            hosting_adapter_id: adapter.id,
            region: region_data["id"],
            name: region_data["name"],
            active: true,
          })
          |> Core.Repo.insert_or_update()

          Enum.each(region_data["plans"], fn (plan_data) ->
            plan = Core.Repo.get_by(Core.Hosting.Plan, [hosting_region_id: db_region.id, plan: plan_data["id"]]) || %Core.Hosting.Plan{}
            {:ok, db_plan} = Core.Hosting.Plan.changeset(plan, %{
              hosting_region_id: db_region.id,
              plan: plan_data["id"],
              name: plan_data["name"],
              active: true,
            })
            |> Core.Repo.insert_or_update()

            Enum.each(plan_data["specs"], fn (spec_data) ->
              spec = Core.Repo.get_by(Core.Hosting.Spec, [hosting_plan_id: db_plan.id, spec: spec_data["id"]]) || %Core.Hosting.Spec{}
              {:ok, _db_spec} = Core.Hosting.Spec.changeset(spec, %{
                hosting_plan_id: db_plan.id,
                spec: spec_data["id"],
                ram: spec_data["ram"],
                cpu: spec_data["cpu"],
                disk: spec_data["disk"],
                transfer: case is_float(spec_data["transfer"]) do
                  true -> trunc(spec_data["transfer"])
                  false -> case is_integer(spec_data["transfer"]) do
                    true -> spec_data["transfer"]
                    false -> 0
                  end
                end,
                dollars_per_hr: spec_data["dollars_per_hr"],
                dollars_per_mo: spec_data["dollars_per_mo"],
                active: true,
              })
              |> Core.Repo.insert_or_update()
            end)
          end)
        end)
        :ok
    end
  end
end
