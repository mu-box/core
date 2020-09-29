# In this file, we load production configuration and
# secrets from environment variables. You can also
# hardcode secrets, although such is generally not
# recommended and you have to remember to add this
# file to your .gitignore.
use Mix.Config

database_url = "ecto://#{System.get_env("DATA_DB_USER") || "postgres"}:#{System.get_env("DATA_DB_PASS") || "postgres"}@#{System.get_env("DATA_DB_HOST") || "localhost"}/gonano"

config :core, Core.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :core, CoreWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "8080"),
    transport_options: [socket_opts: [:inet6]]
  ],
  force_ssl: [rewrite_on: [:x_forwarded_proto], host: nil],
  secret_key_base: secret_key_base

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :core, CoreWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
