defmodule Core.Workers.Steps.Server.Order do
  use Core.Workers.Step

  @impl Core.Workers.Step
  def forward(%Oban.Job{args: %{"instance_id" => instance_id, "account_id" => account_id, "spec_id" => spec_id, "counter" => counter, "generation" => generation}}) do
    job_log :status, "Starting..."
    instance = Core.Applications.get_instance!(instance_id) |> Core.Repo.preload([app: [:user, :team], keys: []])
    account = Core.Hosting.get_account!(account_id) |> Core.Repo.preload([:hosting_adapter])
    spec = Core.Repo.get!(Core.Hosting.Spec, spec_id) |> Core.Repo.preload([plan: [:region]])
    headers = Core.Hosting.get_creds(account) |> Core.Hosting.get_creds_headers()
    title = if instance.app.team_id do
      "#{instance.app.team.slug}.#{instance.app.name}.#{instance.name}.#{account.name}"
    else
      "#{instance.app.user.username}.#{instance.app.name}.#{instance.name}.#{account.name}"
    end

    key = case Enum.find(instance.keys, nil, fn (key) -> key.hosting_account_id == account_id end) do
      nil ->
        job_log :status, "Generating SSH key..."
        with {:ok, key} = Core.Remote.generate_key_attrs(title) |> Map.merge(%{instance_id: instance_id, hosting_account_id: account_id}) |> Core.Remote.create_key() do
          if account.hosting_adapter.ssh_key_method == "reference" do
            with {:ok, response} = HTTPoison.post(account.hosting_adapter.endpoint <> "/keys", %{id: key.title, key: key.public} |> Jason.encode!(), headers) do
              with {:ok, key} = Core.Remote.update_key(key, %{key: response.body |> Jason.decode!() |> Map.get("id")}) do
                key
              end
            end
          else
            key
          end
        end
      key ->
        key
    end

    with %Core.Remote.Key{} = key do
      order_server(instance, account, spec, counter, generation, headers, key)
    end
  end

  @impl Core.Workers.Step
  def back(%Oban.Job{args: %{"instance_id" => instance_id, "account_id" => account_id, "counter" => counter, "generation" => generation}}) do
    instance = Core.Applications.get_instance!(instance_id) |> Core.Repo.preload([app: [:user, :team], keys: []])
    account = Core.Hosting.get_account!(account_id) |> Core.Repo.preload([:hosting_adapter])
    headers = Core.Hosting.get_creds(account) |> Core.Hosting.get_creds_headers()

    cancel_server(instance, account, counter, generation, headers)
  end

  defp order_server(instance, account, spec, counter, generation, headers, key) do
    job_log :status, "Ordering server..."
    server_name = generate_server_name(instance, account, counter, generation)
    body = %{
      name: server_name,
      region: spec.plan.region.region,
      size: spec.spec
    }
    body = case account.hosting_adapter.ssh_auth_method do
      "password" ->
        body
      "key" ->
        case account.hosting_adapter.ssh_key_method do
          "reference" ->
            Map.put(body, :ssh_key, key.key)
          "object" ->
            Map.put(body, :ssh_key, key.public)
        end
    end
    |> Jason.encode!()

    server = with {:ok, response} = HTTPoison.post(account.hosting_adapter.endpoint <> "/servers", body, headers) do
      attrs = %{
        instance_id: instance.id,
        hosting_account_id: account.id,
        spec_id: spec.id,
        server: response.body |> Jason.decode!() |> Map.get("id"),
        status: "creating",
        name: server_name,
        token: :crypto.strong_rand_bytes(24) |> Base.url_encode64(),
      }
      with {:ok, server} = Core.Remote.create_server(attrs) do
        server
      end
    end
    job_log :status, "Server ordered..."

    with %Core.Remote.Server{} = server do
      {:ok, %{server_id: server.id}}
    end
  end

  defp cancel_server(instance, account, counter, generation, headers) do
    job_log :status, "Canceling server..."
    server_name = generate_server_name(instance, account, counter, generation)
    server = Core.Remote.get_server_by_name!(server_name)

    with {:ok, _response} = HTTPoison.delete(account.hosting_adapter.endpoint <> "/servers/" <> server.server, headers) do
      :ok
    end
  end

  defp generate_server_name(instance, account, counter, generation) do
    title = if instance.app.team_id do
      "#{instance.app.team.slug}-#{instance.app.name}-#{instance.name}-#{account.name}"
    else
      "#{instance.app.user.username}-#{instance.app.name}-#{instance.name}-#{account.name}"
    end
    "microbox.cloud-#{title |> String.replace(~r/[ ._]/, "-")}-#{account.hosting_adapter.api}.#{counter}.#{generation}"
  end
end
