defmodule App.MixProject do
  use Mix.Project

  def project do
    [
      app: :app,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {App.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Phoenix deps
      {:phoenix, "~> 1.4.7"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      # App deps
      {:libcluster, "~> 3.1"},                # automatic clustering suport
      {:slugify, "~> 1.3"},                   # convert names into slugs as needed
      {:httpoison, "~> 1.7"},                 # HTTP lib, for accessing external APIs
      # Auth - First factor
      {:argon2_elixir, "~> 2.3"},             # Password hashing
      {:pow, "~> 1.0.13"},                    # User management
      {:mint, "~> 0.1.0"},                    # Pow's HTTP lib dep
      {:castore, "~> 0.1.0"},                 # SSL support for mint
      {:redix, "~> 0.9.2"},                   # Caching
      {:pow_assent, "~> 0.3.2"},              # External services
      # {:ueberauth_heroku, "~> 0.1"},          # Heroku
      # {:ueberauth_microsoft, "~> 0.4"},       # Microsoft
      # {:ueberauth_linkedin, "~> 0.3"},        # LinkedIn
      # Auth - Second factor
      {:elixir2fa, "~> 0.1.0"},               # code generator
      {:passwordless_auth, "~> 0.1.0"},       # SMS
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
