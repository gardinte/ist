defmodule Ist.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ist,
      version: "0.0.1",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      releases: releases()
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
      {:phoenix, ">= 1.4.0"},
      {:phoenix_pubsub, ">= 1.1.0"},
      {:phoenix_html, ">= 2.13.0"},
      {:phoenix_ecto, ">= 4.0.0"},
      {:ecto_sql, ">= 3.2.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_live_reload, ">= 1.2.0", only: :dev},
      {:jason, ">= 1.1.0"},
      {:gettext, ">= 0.17.0"},
      {:plug_cowboy, ">= 2.1.0"},
      {:argon2_elixir, ">= 2.1.0"},
      {:scrivener_ecto, ">= 2.2.0"},
      {:scrivener_html, ">= 1.8.0"},
      {:bamboo, ">= 1.3.0"},
      {:paper_trail, ">= 0.8.0"}
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

  defp releases do
    [
      ist: [
        include_executables_for: [:unix],
        applications: [runtime_tools: :permanent]
      ]
    ]
  end
end
