defmodule Core.Workers.Step do
  @callback forward(job :: Oban.Job.t()) :: Oban.Worker.result()
  @callback back(job :: Oban.Job.t()) :: Oban.Worker.result()

  @doc false
  defmacro __using__(_opts) do
    quote location: :keep do
      use Oban.Worker,
        queue: :default,
        priority: 0,
        max_attempts: 1

      @behaviour Core.Workers.Step

      defmodule Storage do
        def start_link do
          Agent.start_link(fn -> Keyword.new() end, name: __MODULE__)
        end

        def put(key, value) do
          Agent.update(__MODULE__, fn (x) -> Keyword.put(x, key, value) end)
        end

        def get(key, default \\ nil) do
          Agent.get(__MODULE__, fn (x) -> Keyword.get(x, key, default) end)
        end
      end

      @impl Oban.Worker
      def perform(%Oban.Job{args: %{"flow_id" => %{"name" => flow_name, "node" => flow_node}, "instance_id" => instance_id, "flow_undo" => undo}} = job) do
        flow_id = {String.to_atom(flow_name), String.to_atom(flow_node)}
        Storage.start_link
        Storage.put(:job, job)
        Storage.put(:instance, Core.Applications.get_instance!(instance_id))

        if undo do
          back(job)
        else
          forward(job)
        end
        |> case do
          result ->
            Process.send(flow_id, result, [])
            result
        end
      end

      @impl Oban.Worker
      def backoff(%Oban.Job{unsaved_error: unsaved_error} = job) do
        %{kind: _, reason: reason, stacktrace: _} = unsaved_error

        job_log(:error, inspect(reason))

        Oban.Worker.backoff(job)
      end

      def job_log(level, line) do
        Core.Tracking.create_job_log(%{
          instance: Storage.get(:instance),
          worker: Storage.get(:job).worker,
          args: Storage.get(:job).args,
          attempt: Storage.get(:job).attempt,
          level: level,
          line: line,
        })
      end
    end
  end
end
