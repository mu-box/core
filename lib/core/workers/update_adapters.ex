defmodule Core.Workers.UpdateAdapters do
  use Oban.Worker,
    queue: :default,
    priority: 3,
    max_attempts: 1

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"adapter_id" => adapter_id}}) do
    Core.Hosting.get_adapter!(adapter_id)
    |> Core.Hosting.Adapter.populate_config()
  end

  def perform(_) do
    Core.Hosting.list_adapters()
    |> Enum.each(fn (adapter) ->
      %{adapter_id: adapter.id}
      |> Core.Workers.UpdateAdapters.new(max_attempts: 3)
      |> Oban.insert()
    end)

    :ok
  end
end
