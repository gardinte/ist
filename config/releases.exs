import Config

config :ist, IstWeb.Endpoint, secret_key_base: System.fetch_env!("SECRET_KEY_BASE")

config :ist, Ist.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.fetch_env!("DATABASE_URL"),
  pool_size: 15

config :ist, Ist.Notifications.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: System.fetch_env!("SENDGRID_API_KEY")
