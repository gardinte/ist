use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ist, IstWeb.Endpoint,
  http: [port: 4001],
  server: false

# Gettext config
config :ist, IstWeb.Gettext, default_locale: "en"

# Bamboo test adapter
config :ist, Ist.Notifications.Mailer, adapter: Bamboo.TestAdapter

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :ist, Ist.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "ist_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :argon2_elixir,
  t_cost: 1,
  m_cost: 3
