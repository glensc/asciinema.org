use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :asciinema, Asciinema.Endpoint,
  http: [port: 4001],
  secret_key_base: "ssecretkeybasesecretkeybasesecretkeybasesecretkeybaseecretkeybase",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :asciinema, Asciinema.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  username: "postgres",
  password: "postgres",
  database: "asciinema_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :asciinema, :file_store, Asciinema.FileStore.Local
config :asciinema, Asciinema.FileStore.Local, path: "uploads/test/"

config :asciinema, :poster_generator, Asciinema.Asciicasts.PosterGenerator.Noop
