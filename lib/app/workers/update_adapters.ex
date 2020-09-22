defmodule App.Workers.UpdateAdapters do
  use Oban.Worker,
    queue: :default,
    priority: 3,
    max_attempts: 1

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"adapter_id" => adapter_id}}) do
    App.Hosting.get_adapter!(adapter_id)
    |> App.Hosting.Adapter.populate_config()
  end

  def perform(_) do
    App.Hosting.list_adapters()
    |> Enum.each(fn (adapter) ->
      %{adapter_id: adapter.id}
      |> App.Workers.UpdateAdapters.new(max_attempts: 3)
      |> Oban.insert()
    end)

    :ok
  end
end
