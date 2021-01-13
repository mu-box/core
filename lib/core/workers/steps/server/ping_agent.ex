defmodule Core.Workers.Steps.Server.PingAgent do
  use Core.Workers.Step

  @impl Core.Workers.Step
  def forward(%Oban.Job{args: %{"server_id" => server_id}}) do
    server = Core.Remote.get_server!(server_id) |> Core.Repo.preload([hosting_account: [:hosting_adapter], instance: [:keys]])

    with {:ok, _response} = HTTPoison.get("https://#{server.external_ip}:8570/ping", [{"x-token", [server.token]}]) do
      job_log :status, "Server online!"

      Core.Remote.update_server(server, %{status: "active"})
    end
  end

  @impl Core.Workers.Step
  def back(%Oban.Job{args: %{}}) do
    # No op? Or TODO?
    :ok
  end
end
