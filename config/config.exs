# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
#
# General application configuration
import Config

config :ist,
  ecto_repos: [Ist.Repo]

# Configures the endpoint
config :ist, IstWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aSDqqkTxP1sqnCfAtisHN1She4oowrocoYtIGg2NOxnl5seeL9bGmQl2j2QFSXea",
  render_errors: [view: IstWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ist.PubSub, adapter: Phoenix.PubSub.PG2]

# Gettext config
config :ist, IstWeb.Gettext, default_locale: "es_AR"

# Ecto timestamps
config :ist, Ist.Repo, migration_timestamps: [type: :utc_datetime]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix and Ecto
config :phoenix, :json_library, Jason

# PaperTrail config
config :paper_trail, repo: Ist.Repo

# Scrivener HTML config
config :scrivener_html,
  routes_helper: IstWeb.Router.Helpers,
  view_style: :bulma

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
