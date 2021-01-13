defmodule Core.Workers.Flow do
  @callback build() :: any

  @type reason :: {:retry, integer} | :skip | {:rollback, integer} | :skipback | :wait | {:abort, any}

  @doc false
  defmacro __using__(_opts) do
    quote location: :keep do
      use Oban.Worker,
        queue: :default,
        priority: 1,
        max_attempts: 1

      @behaviour Core.Workers.Flow

      defmodule Storage do
        def start_link do
          Agent.start_link(fn -> Keyword.new() end, name: __MODULE__)
        end

        def put(key, value) do
          Agent.update(__MODULE__, fn (x) -> Keyword.put(x, key, value) end)
        end

        def delete(key) do
          Agent.update(__MODULE__, fn (x) -> Keyword.drop(x, [key]) end)
        end

        def get(key, default \\ nil) do
          Agent.get(__MODULE__, fn (x) -> Keyword.get(x, key, default) end)
        end
      end

      @impl Oban.Worker
      def perform(%Oban.Job{args: args}) do
        Process.register(self(), String.to_atom(inspect(self())))
        Storage.start_link
        Storage.put(:args, Map.merge(args, %{flow_id: %{name: inspect(self()), node: Node.self()}}))

        upstream = case args do
          %{"flow_id" => %{"name" => flow_name, "node" => flow_node}} ->
            {String.to_atom(flow_name), String.to_atom(flow_node)}
          _else ->
            nil
        end

        build()

        failed_at = case args do
          %{"flow_undo" => true} ->
            Storage.get(:steps, [])
            |> Enum.reverse()
            |> Enum.find_index(fn {worker, args} -> undo_step(worker, args) end)
          _else ->
            Storage.get(:steps, [])
            |> Enum.find_index(fn {worker, args} -> run_step(worker, args) end)
        end

        result = if is_nil(failed_at) do
          :ok
        else
          failure_type(0)
          |> failure_react(failed_at)
        end

        if not is_nil(upstream) do
          Process.send(upstream, result, [])
        end

        result
      end

      @spec step(atom, map) :: any
      def step(worker, args \\ %{}) do
        Storage.put(:steps, Storage.get(:steps, []) ++ [{worker, args}])
      end

      @spec run_step(atom, map) :: boolean
      defp run_step(worker, args) do
        args
        |> Map.merge(Storage.get(:args, %{}))
        |> Map.merge(%{flow_undo: false})
        |> worker.new()
        |> Oban.insert()

        handle_message()
      end

      @spec undo_step(atom, map) :: boolean
      defp undo_step(worker, args) do
        args
        |> Map.merge(Storage.get(:args, %{}))
        |> Map.merge(%{flow_undo: true})
        |> worker.new()
        |> Oban.insert()

        handle_message()
      end

      @spec handle_message() :: boolean
      defp handle_message do
        receive do
          :ok ->
            false

          {:ok, args} ->
            Storage.put(:args, Storage.get(:args, %{}) |> Map.merge(args))
            false

          :cancel ->
            handle_message()
            Storage.put(:failed_for, {:cancel, Storage.get(:failed_for, :ok)})
            true

          {:error, reason} ->
            Storage.put(:failed_for, reason)
            true
        end
      end

      @spec failure_type(integer, boolean) :: Core.Workers.Flow.reason
      defp failure_type(count, rollback \\ false) do
        out = case Storage.get(:failed_for) do
          {:cancel, :ok} ->
            {:rollback, count + 1}
          {:cancel, reason} ->
            Storage.put(:failed_for, reason)
            case failure_type(count, rollback) do
              reason ->
                {:abort, "Unhandled cancel: #{inspect(reason)}"}
            end
          reason ->
            {:abort, "Unhandled failure: #{inspect(reason)}"}
        end

        Storage.delete(:failed_for)

        out
      end

      @spec failure_react(Core.Workers.Flow.reason, integer) :: Oban.Worker.result()
      defp failure_react(reaction, failed_at) do
        case reaction do
          {:retry, count} ->
            failed_again =
              Storage.get(:steps, [])
              |> Enum.slice(failed_at..-1)
              |> Enum.find_index(fn {worker, args} -> run_step(worker, args) end)

            if is_nil(failed_again) do
              :ok
            else
              failure_type(count)
              |> failure_react(failed_again)
            end
          :skip ->
            failed_again =
              Storage.get(:steps, [])
              |> Enum.slice((failed_at + 1)..-1)
              |> Enum.find_index(fn {worker, args} -> run_step(worker, args) end)

            if is_nil(failed_again) do
              :ok
            else
              failure_type(0)
              |> failure_react(failed_again)
            end
          {:rollback, count} ->
            failed_again =
              Storage.get(:steps, [])
              |> Enum.slice(0..failed_at)
              |> Enum.reverse()
              |> Enum.find_index(fn {worker, args} -> undo_step(worker, args) end)

            if is_nil(failed_again) do
              {:error, "Rolled back"}
            else
              failure_type(count, true)
              |> failure_react(failed_at - failed_again)
            end
          :skipback ->
            failed_again =
              Storage.get(:steps, [])
              |> Enum.slice(0..(failed_at - 1))
              |> Enum.reverse()
              |> Enum.find_index(fn {worker, args} -> undo_step(worker, args) end)

            if is_nil(failed_again) do
              {:error, "Rolled back"}
            else
              failure_type(0, true)
              |> failure_react(failed_at - failed_again)
            end
          :wait ->
            receive do
              {:act, value} ->
                failure_react(value, failed_at)
              _else ->
                failure_react(reaction, failed_at)
            end
          {:abort, reason} ->
            {:error, reason}
        end
      end
    end
  end
end
