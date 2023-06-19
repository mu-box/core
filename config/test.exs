use Mix.Config

# Configure your database
config :core, Core.Repo,
  username: System.get_env("DATA_DB_USER") || "postgres",
  password: System.get_env("DATA_DB_PASS") || "postgres",
  hostname: System.get_env("DATA_DB_HOST") || "localhost",
  database: "gomicro_test",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :core, CoreWeb.Endpoint,
  http: [port: 4002],
  server: false,
  secret_key_base: "3PXN/6k6qoxqQjWFskGew4r74yp7oJ1UNF6wjvJSHjC5Y5LLIrDpWxrJ84UBphJn"

# Print only warnings and errors during test
config :logger, level: :warn

config :core, Oban,
  crontab: false, queues: false, plugins: false
