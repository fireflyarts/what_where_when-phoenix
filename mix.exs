defmodule WhatWhereWhen.MixProject do
  use Mix.Project

  def project do
    [
      app: :what_where_when,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
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
      mod: {WhatWhereWhen.Application, []},
      extra_applications: [:logger, :runtime_tools]
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
      # framework and view layers
      {:esbuild, "~> 0.4", runtime: Mix.env() == :dev},
      {:phoenix, "~> 1.6.10"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_view, "~> 0.17.5"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},

      # api layer
      # for JSON parsing in Phoenix
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},

      # db/data layer
      {:ecto_sql, "~> 3.6"},
      {:ecto_sqlite3, "~> 0.7.5"},
      {:phoenix_ecto, "~> 4.4"},

      # encoding
      {:emojix, "~> 0.3.0"},

      # testing layer
      {:floki, ">= 0.30.0", only: :test},

      # operations/monitoring layer
      {:phoenix_live_dashboard, "~> 0.6", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"}

      # disabled, kept for discoverability
      # {:swoosh, "~> 1.3"}, # for sending emails
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end
end
