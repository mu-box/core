# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :app,
  ecto_repos: [App.Repo]

# Configures the endpoint
config :app, AppWeb.Endpoint,
  url: [host: "172.20.0.45"],
  secret_key_base: "aWXVc7dM7K8NbZmZNb6uAOIXGvjkqyvuBZPvJ3pqzHK5pXrdF8U1Kv9vdSUycovZ",
  render_errors: [view: AppWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: App.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :app, :pow,
  user: App.Users.User,
  repo: App.Repo,
  extensions: [PowResetPassword, PowEmailConfirmation, PowPersistentSession, PowInvitation],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  web_module: AppWeb,
  web_mailer_module: AppWeb,
  mailer_backend: AppWeb.PowMailer,
  routes_backend: AppWeb.PowRoutes,
  cache_store_backend: AppWeb.PowRedisCache

config :app, :pow_assent,
  http_adapter: PowAssent.HTTPAdapter.Mint,
  providers: [
    auth0: [
      client_id: System.get_env("AUTH0_CLIENT_ID"),
      client_secret: System.get_env("AUTH0_CLIENT_SECRET"),
      domain: System.get_env("AUTH0_DOMAIN"),
      strategy: PowAssent.Strategy.Auth0
    ],
    facebook: [
      client_id: System.get_env("FACEBOOK_CLIENT_ID"),
      client_secret: System.get_env("FACEBOOK_CLIENT_SECRET"),
      strategy: PowAssent.Strategy.Facebook
    ],
    github: [
      client_id: System.get_env("GITHUB_CLIENT_ID"),
      client_secret: System.get_env("GITHUB_CLIENT_SECRET"),
      strategy: PowAssent.Strategy.Github
    ],
    gitlab: [
      client_id: System.get_env("GITLAB_CLIENT_ID"),
      client_secret: System.get_env("GITLAB_CLIENT_SECRET"),
      strategy: PowAssent.Strategy.Gitlab
    ],
    google: [
      client_id: System.get_env("GOOGLE_CLIENT_ID"),
      client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
      strategy: PowAssent.Strategy.Google
    ],
    twitter: [
      client_id: System.get_env("TWITTER_CLIENT_ID"),
      client_secret: System.get_env("TWITTER_CLIENT_SECRET"),
      strategy: PowAssent.Strategy.Twitter
    ]
  ]

config :ex_twilio,
  account_sid: System.get_env("TWILIO_ACCOUNT_SID"),
  auth_token: System.get_env("TWILIO_AUTH_TOKEN"),
  workspace_sid: System.get_env("TWILIO_WORKSPACE_SID") # optional

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
