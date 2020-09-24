defmodule AppWeb.API.AdapterController do
  use AppWeb, :controller

  alias App.Hosting
  alias App.Hosting.Adapter

  action_fallback AppWeb.FallbackController

  def register(conn, %{"id" => id, "endpoint" => endpoint}) do
    adapter = Hosting.get_adapter!(id)

    if adapter.endpoint do
      conn
      |> put_status(409)
      |> put_view(AppWeb.APIView)
      |> render("error.json", message: "Already registered.")
    else
      with {:ok, %Adapter{} = adapter} <- Hosting.update_adapter(adapter, %{endpoint: endpoint, unlink_code: Adapter.generate_unlink_code()}) do
        %{adapter_id: adapter.id}
        |> App.Workers.UpdateAdapters.new(priority: 1)
        |> Oban.insert()

        render(conn, "adapter.json", adapter: adapter)
      end
    end
  end

  def unregister(conn, %{"id" => id, "unlink_code" => unlink_code}) do
    adapter = Hosting.get_adapter!(id)

    case adapter.unlink_code do
      ^unlink_code ->
        adapter = adapter |> App.Repo.preload([:fields, :regions])
        unless adapter.global do
          Enum.each(adapter.fields, fn (field) ->
            field |> App.Repo.delete()
          end)
          Enum.each(adapter.regions, fn (region) ->
            region = region |> App.Repo.preload([:plans])
            Enum.each(region.plans, fn (plan) ->
              plan = plan |> App.Repo.preload([:specs])
              Enum.each(plan.specs, fn (spec) ->
                spec |> App.Repo.delete()
              end)
              plan |> App.Repo.delete()
            end)
            region |> App.Repo.delete()
          end)
          with {:ok, %Adapter{}} <- Hosting.delete_adapter(adapter) do
            send_resp(conn, :no_content, "")
          end
        else
          conn
          |> put_status(409)
          |> put_view(AppWeb.APIView)
          |> render("error.json", message: "Can't unlink a global adapter.")
        end
      _else ->
        conn
        |> put_status(401)
        |> put_view(AppWeb.APIView)
        |> render("error.json", message: "Incorrect unlink code.")
    end
  end
end
