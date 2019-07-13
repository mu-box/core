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
        :runtime_tools,
        :ueberauth,
        :ueberauth_identity,
        :ueberauth_github,
        :ueberauth_gitlab_strategy,
        :ueberauth_heroku,
        :ueberauth_auth0,
        :ueberauth_google,
        :ueberauth_microsoft,
        :ueberauth_facebook,
        :ueberauth_linkedin,
        :ueberauth_twitter
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
      {:ueberauth, "~> 0.6"},                 # First factor, core
      {:ueberauth_identity, "~> 0.2"},        # First factor, username/password
      {:ueberauth_github, "~> 0.7"},          # First factor, GitHub
      {:ueberauth_gitlab_strategy, "~> 0.2"}, # First factor, GitLab
      {:ueberauth_heroku, "~> 0.1"},          # First factor, Heroku
      {:ueberauth_auth0, "~> 0.3"},           # First factor, Auth0
      {:ueberauth_google, "~> 0.8"},          # First factor, Google
      {:ueberauth_microsoft, "~> 0.4"},       # First factor, Microsoft
      {:ueberauth_facebook, "~> 0.8"},        # First factor, Facebook
      {:ueberauth_linkedin, "~> 0.3"},        # First factor, LinkedIn
      {:ueberauth_twitter, "~> 0.2"},         # First factor, Twitter
      {:elixir2fa, "~> 0.1.0"},               # Second factor, generator
      {:passwordless_auth, "~> 0.1.0"},       # Second factor, SMS
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
