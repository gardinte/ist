import Config

config :ist, IstWeb.Endpoint,
  force_ssl: [
    host: nil,
    hsts: true,
    preload: true,
    subdomains: true
  ],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE")

config :ist, Ist.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.fetch_env!("DATABASE_URL"),
  pool_size: 15

config :ist, Ist.Notifications.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: System.fetch_env!("SENDGRID_API_KEY")

config :ist, bucket: System.fetch_env!("BUCKET")

config :psb,
  process_topic: System.fetch_env!("PUBSUB_PROCESS_TOPIC"),
  publish_topic: System.fetch_env!("PUBSUB_PUBLISH_TOPIC"),
  project: System.fetch_env!("PUBSUB_PROJECT")
