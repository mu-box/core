defmodule Core.Workers.Steps.Platform.InstallImage do
  use Core.Workers.Step

  @services %{
    "portal" => "nanobox/portal:latest",
    "mist" => "nanobox/mist:latest",
    "logvac" => "nanobox/logvac:latest",
    "pulse" => "nanobox/pulse:latest",
    "hoarder" => "nanobox/hoarder:latest",
  }

  @impl Core.Workers.Step
  def forward(%Oban.Job{args: %{"server_id" => server_id, "service" => service}}) do
    server = Core.Remote.get_server!(server_id)

    with {:ok, response} = HTTPoison.get("https://#{server.external_ip}:8570/images", [{"x-token", [server.token]}]) do
      images = response |> Jason.decode!() |> Enum.map(fn img -> img.slug end)
      image = @services |> Map.get(service, nil)

      if not (images |> Enum.any?(fn img -> img == image end)) do
        with {:ok, _response} = HTTPoison.post("https://#{server.external_ip}:8570/images", Jason.encode!(%{slug: image}), [{"x-token", [server.token]}]) do
          wait_for_ready(server, image)
        end
      end
    end
  end

  @impl Core.Workers.Step
  def back(%Oban.Job{args: %{}}) do
    # No op? Or TODO?
    :ok
  end

  defp wait_for_ready(server, image) do
    with {:ok, response} = HTTPoison.get("https://#{server.external_ip}:8570/images/#{image}", [{"x-token", [server.token]}]) do
      status = response |> Jason.decode!() |> Map.get("status", "")

      if status != "complete" do
        Process.sleep(500)
        wait_for_ready(server, image)
      else
        :ok
      end
    end
  end
end
