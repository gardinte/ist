import Config

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
  username: if(System.get_env("TRAVIS"), do: "postgres", else: "ist"),
  password: if(System.get_env("TRAVIS"), do: "postgres", else: "ist"),
  database: "ist_test",
  hostname: System.get_env("DATABASE_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Recording's bucket
config :ist, bucket: "gardinfra-development-testing"

# Argon
config :argon2_elixir,
  t_cost: 1,
  m_cost: 5

# PubSub
config :psb,
  process_topic: "development-testing-process",
  publish_topic: "development-testing-publish",
  project: "gardinfra-development"
