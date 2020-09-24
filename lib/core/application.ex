defmodule Core.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    topologies = [
      gossip: [
        strategy: Cluster.Strategy.Gossip,
        config: [
          secret: "microbox",
        ],
      ]
    ]

    # List all child processes to be supervised
    children = [
      {Cluster.Supervisor, [topologies, [name: Core.ClusterSupervisor]]},
      # Start the Ecto repository
      Core.Repo,
      # Start the endpoint when the application starts
      CoreWeb.Endpoint,
      # Starts a worker by calling: Core.Worker.start_link(arg)
      # {Core.Worker, arg},
      {Redix, host: System.get_env("DATA_CACHE_HOST"), name: :redix},
      {Oban, oban_config()},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Core.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CoreWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  # Conditionally disable crontab, queues, or plugins here.
  defp oban_config do
    Application.get_env(:core, Oban)
  end
end
