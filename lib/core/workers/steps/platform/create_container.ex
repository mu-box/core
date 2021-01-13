defmodule Core.Workers.Steps.Platform.CreateContainer do
  use Core.Workers.Step

  @images %{
    "portal" => "nanobox/portal:latest",
    "mist" => "nanobox/mist:latest",
    "logvac" => "nanobox/logvac:latest",
    "pulse" => "nanobox/pulse:latest",
    "hoarder" => "nanobox/hoarder:latest",
  }

  @names %{
    "portal" => "mesh",
    "mist" => "pusher",
    "logvac" => "logger",
    "pulse" => "monitor",
    "hoarder" => "warehouse",
  }

  @ports %{
    "portal" => 8443,
    "mist" => 1445,
    "logvac" => 6360,
    "pulse" => 5531,
    "hoarder" => 7410,
  }

  @impl Core.Workers.Step
  def forward(%Oban.Job{args: %{"server_id" => server_id, "service" => service_name}}) do
    server = Core.Remote.get_server!(server_id) |> Core.Repo.preload([:instance])
    image = @images |> Map.get(service_name, nil)
    slug = @names |> Map.get(service_name, nil)
    service =
      case Core.Applications.get_service_by_instance_and_slug(server.instance.id, slug) do
        %Core.Applications.Service{} = service ->
          service
        nil ->
          %{
            uid: slug <> "1",
            name: slug,
            slug: slug,
            ip: server.external_ip,
            url: server.external_ip,
            token: :crypto.strong_rand_bytes(24) |> Base.url_encode64(),
            mode: "simple",
          }
          |> Core.Applications.create_service()
      end
    component =
      case Core.Components.get_component_by_service_and_name(service.id, "#{slug}.data.#{service_name}") do
        %Core.Components.Component{} = component ->
          component
        nil ->
          %{
            service_id: service.id,
            name: "#{slug}.data.#{service_name}",
            uid: "#{slug}.data.#{service_name}",
            deploy_strategy: "inline",
            repair_strategy: "inline",
            behaviors: [],
            port: @ports |> Map.get(service_name, nil),
            category: "platform",
            current_generation: 0,
            horizontal: false,
            redundant: false,
          }
          |> Core.Components.create_component()
      end
    generation =
      case Core.Components.get_generation_by_component_and_counter(component.id, component.current_generation + 1) do
        %Core.Components.Generation{} = generation ->
          generation
        nil ->
          %{
            component_id: component.id,
            image: image,
            counter: component.current_generation + 1,
          }
          |> Core.Components.create_generation()
      end
    member =
      case Core.Components.get_member_by_generation_and_counter(generation.id, 1) do
        %Core.Components.Member{} = member ->
          member
        nil ->
          %{
            generation_id: generation.id,
            counter: 1,
            state: "creating",
            pulse: "offline",
            network: "virt",
          }
          |> Core.Components.create_member()
      end
    if nil == Core.Components.get_server_by_ids(server.id, member.id) do
      %{
        server_id: server.id,
        member_id: member.id,
      }
      |> Core.Components.create_server()
    end

    payload = %{
      image_slug: image,
      name: "#{component.name}.#{generation.counter}.#{member.counter}",
      hostname: "#{component.name}.#{generation.counter}.#{member.counter}",
      domainname: "",
      labels: %{
        component: component.id,
        generation: generation.id,
        member: member.id,
      },
      cmd: nil,
      network: "virt",
      ip: "", # TODO
      memory: 0,
      memory_swap: 0,
      cpu_shares: 0,
    }

    with {:ok, _response} = HTTPoison.post("https://#{server.external_ip}:8570/containers", Jason.encode!(payload), [{"x-token", [server.token]}]) do
      with :ok = wait_for_ready(server, payload.name) do
        {:ok, %{"member_id" => member.id}}
      end
    end
  end

  @impl Core.Workers.Step
  def back(%Oban.Job{args: %{}}) do
    # No op? Or TODO?
    :ok
  end

  defp wait_for_ready(server, member) do
    with {:ok, response} = HTTPoison.get("https://#{server.external_ip}:8570/containers/#{member}", [{"x-token", [server.token]}]) do
      status = response |> Jason.decode!() |> Map.get("status", "")

      if status != "running" do
        Process.sleep(500)
        wait_for_ready(server, member)
      else
        :ok
      end
    end
  end
end
