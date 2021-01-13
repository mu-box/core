defmodule Core.Workers.Steps.Server.WaitForReady do
  use Core.Workers.Step

  @impl Core.Workers.Step
  def forward(%Oban.Job{args: %{"server_id" => server_id}}) do
    server = Core.Remote.get_server!(server_id) |> Core.Repo.preload([hosting_account: [:hosting_adapter], instance: [:keys]])
    headers = Core.Hosting.get_creds(server.hosting_account) |> Core.Hosting.get_creds_headers()
    key = Enum.find(server.instance.keys, nil, fn (key) -> key.hosting_account_id == server.hosting_account_id end)

    server = with %Core.Remote.Server{} = wait_for_ready(server.hosting_account.hosting_adapter.endpoint, headers, server) do
      Core.Remote.get_server!(server.id)
    end

    with %Core.Remote.Server{} = server do
      if server.hosting_account.hosting_adapter.ssh_auth_method == "password" do
        job_log :status, "Installing SSH key..."
        {:ok, _response} = HTTPoison.patch(server.hosting_account.hosting_adapter.endpoint <> "/servers/" <> server.id <> "/keys", %{id: key.title, key: key.public} |> Jason.encode!(), headers)
      end

      server = with {:ok, server} = Core.Remote.update_server(server, %{status: "provisioning"}) do
        server
      end
      job_log :status, "Server created!"

      with %Core.Remote.Server{} = server do
        :ok
      end
    end
  end

  @impl Core.Workers.Step
  def back(%Oban.Job{args: %{}}) do
    # No op? Or TODO?
    :ok
  end

  defp wait_for_ready(endpoint, headers, server) do
    with {:ok, response} = HTTPoison.get(endpoint <> "/servers/" <> server.server, headers) do
      attrs = response |> Jason.decode!()
      with {:ok, server} = Core.Remote.update_server(server, %{status: attrs["status"], internal_ip: attrs["internal_ip"], external_ip: attrs["external_ip"]}) do
        if server.status != "active" do
          Process.sleep(1000)
          wait_for_ready(endpoint, headers, server)
        else
          server
        end
      end
    end
  end
end
