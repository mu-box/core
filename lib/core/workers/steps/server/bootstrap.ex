defmodule Core.Workers.Steps.Server.Bootstrap do
  use Core.Workers.Step

  @impl Core.Workers.Step
  def forward(%Oban.Job{args: %{"server_id" => server_id}}) do
    server = Core.Remote.get_server!(server_id) |> Core.Repo.preload([hosting_account: [:hosting_adapter], instance: [:keys]])
    key = Enum.find(server.instance.keys, nil, fn (key) -> key.hosting_account_id == server.hosting_account_id end)

    job_log :status, "Starting bootstrap..."
    with {:ok, conn} = SSHEx.connect(
      ip: to_charlist(server.external_ip),
      user: to_charlist(server.hosting_account.hosting_adapter.ssh_user),
      key_cb: {SSHEx.ConfigurableClientKeys, [
        key: StringIO.open(key.private),
        known_hosts: StringIO.open(""),
        accept_hosts: true
      ]}
    ) do
      SSHEx.cmd! conn, to_charlist("curl -f -k -o /tmp/bootstrap " <> server.hosting_account.hosting_adapter.bootstrap_script)
      SSHEx.cmd! conn, to_charlist("chmod +x /tmp/bootstrap")

      command = "set -o pipefail; /tmp/bootstrap " <>
                "id=#{server.name |> String.split("-") |> List.last()} " <>
                "token=#{server.token} " <>
                "internal-iface=#{server.hosting_account.hosting_adapter.internal_iface} " <>
                "external-iface=#{server.hosting_account.hosting_adapter.external_iface} " <>
                # "vip=#{} " <> # TODO
                "| tee -a ~/.bootstrap.log"
      str = SSHEx.stream conn, to_charlist(command)

      Enum.each(str, fn(x)->
        case x do
          {:stdout, row}    -> process_output(row)
          {:stderr, row}    -> process_output(row)
          {:status, status} -> process_exit_status(status)
          {:error, reason}  -> process_error(reason)
        end
      end)
      job_log :status, "Server bootstrapped!"
    end
  end

  @impl Core.Workers.Step
  def back(%Oban.Job{args: %{}}) do
    # No op? Or TODO?
    :ok
  end

  defp process_output(row) do
    job_log :info, row
  end

  defp process_exit_status(status) do
    if status != 0 do
      exit("Bootstrap script exited with #{status}")
    end
  end

  defp process_error(reason) do
    exit("Bootstrap Error: #{reason}")
  end
end
