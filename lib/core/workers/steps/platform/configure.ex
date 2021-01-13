defmodule Core.Workers.Steps.Platform.Configure do
  use Core.Workers.Step

  @impl Core.Workers.Step
  def forward(%Oban.Job{args: %{"member_id" => member_id}}) do
    member = Core.Components.get_member!(member_id) |> Core.Repo.preload([generation: [:component], server: []])

    payload = %{
      container: "#{member.generation.component.name}.#{member.generation.counter}.#{member.counter}",
      hook: "configure",
      payload: "",
    }

    with {:ok, response} = HTTPoison.post("https://#{member.server.external_ip}:8570/jobs", Jason.encode!(payload), [{"x-token", [member.server.token]}]) do
      with :ok = wait_for_finished(member.server, response |> Jason.decode!() |> Map.get("id")) do
        :ok
      end
    end
  end

  @impl Core.Workers.Step
  def back(%Oban.Job{args: %{}}) do
    # No op? Or TODO?
    :ok
  end

  defp wait_for_finished(server, job) do
    with {:ok, response} = HTTPoison.get("https://#{server.external_ip}:8570/jobs/#{job}", [{"x-token", [server.token]}]) do
      running = response |> Jason.decode!() |> Map.get("running", nil)

      if running do
        Process.sleep(500)
        wait_for_finished(server, job)
      else
        :ok
      end
    end
  end
end
