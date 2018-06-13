defmodule Ist.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ist,
      version: "0.0.1",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Ist.Application, []},
      extra_applications: [:logger, :runtime_tools, :mix]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, ">= 1.3.0"},
      {:phoenix_pubsub, ">= 1.0.0"},
      {:phoenix_ecto, ">= 3.3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, ">= 2.11.0"},
      {:phoenix_live_reload, ">= 1.1.0", only: :dev},
      {:gettext, ">= 0.15.0"},
      {:cowboy, ">= 1.1.0"},
      {:comeonin, ">= 4.1.0"},
      {:argon2_elixir, ">= 1.3.0"},
      {:scrivener_ecto, ">= 1.3.0"},
      {:scrivener_html, ">= 1.7.0"},
      {:bamboo, ">= 0.8.0"},
      {:bamboo_smtp, ">= 1.4.0"},
      {:paper_trail, ">= 0.8.0"},
      {:edeliver, ">= 1.5.0"},
      {:pid_file, ">= 0.1.0"},
      {:distillery, ">= 1.5.0", runtime: false, warn_missing: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "run priv/repo/test_seeds.exs", "test"]
    ]
  end
end
