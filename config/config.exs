# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# run shell command to "source .env" to load the environment variables.
try do                                     # wrap in "try do"
  File.stream!("./.env")                   # in case .env file does not exist.
    |> Stream.map(&String.trim_trailing/1) # remove excess whitespace
    |> Enum.each(fn line -> line           # loop through each line
      |> String.replace("export ", "")     # remove "export" from line
      |> String.split("=", parts: 2)       # split on *first* "=" (equals sign)
      |> Enum.reduce(fn(value, key) ->     # stackoverflow.com/q/33055834/1148249
        System.put_env(key, value)         # set each environment variable
      end)
    end)
rescue
  _ -> IO.puts "no .env file found!"
end

config :core,
  ecto_repos: [Core.Repo]

config :core, Core.Repo,
  migration_primary_key: [name: :id, type: :binary_id]

# Configures the endpoint
config :core, CoreWeb.Endpoint,
  url: [host: "microbox.cloud", port: 80],
  http: [port: 8080],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [view: CoreWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Core.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :core, Oban,
  repo: Core.Repo,
  plugins: [{Oban.Plugins.Pruner, max_age: 86_400}],
  queues: [default: 100],
  crontab: [
    {"@daily", Core.Workers.UpdateAdapters}
  ]

# Set the Encryption Keys as an "Application Variable" accessible in aes.ex
config :core, Encryption.AES,
  keys: System.get_env("ENCRYPTION_KEYS") # get the ENCRYPTION_KEYS env variable
    |> String.replace("'", "")  # remove single-quotes around key list in .env
    |> String.split(",")        # split the CSV list of keys
    |> Enum.map(fn key -> :base64.decode(key) end) # decode the key.

config :argon2_elixir,
  argon2_type: 2

config :core, :pow,
  user: Core.Accounts.User,
  repo: Core.Repo,
  extensions: [PowResetPassword, PowEmailConfirmation, PowPersistentSession, PowInvitation],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  web_module: CoreWeb,
  web_mailer_module: CoreWeb,
  mailer_backend: CoreWeb.PowMailer,
  routes_backend: CoreWeb.PowRoutes,
  cache_store_backend: CoreWeb.PowRedisCache

config :core, :pow_assent,
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
