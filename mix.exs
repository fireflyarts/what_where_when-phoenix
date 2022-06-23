defmodule WhatWhereWhen.MixProject do
  use Mix.Project

  # Dependencies as will be installed by running `mix deps.get`
  # Analogous to the "dependencies" (and "devDependencies") section(s) of a package.json
  #
  # I have chosen to arrange them specifically in a
  # frontend ("top of stack") to backend ("bottom of stack") order
  defp deps do
    [
      # Frontend/View layer
      {:esbuild, "~> 0.5", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.1.6", runtime: Mix.env() == :dev},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_view, "~> 0.17.5"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},

      # Routing/auth/controller layer
      {:phoenix, "~> 1.6.10"},
      {:plug_cowboy, "~> 2.5"},
      {:bcrypt_elixir, "~> 3.0"},

      # API layer
      {:jason, "~> 1.2"},
      # emoji encoding
      {:emojix, "~> 0.3.0"},
      # time parsing
      {:timex, "~> 3.0"},

      # DB/Data layer
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.6"},
      {:ecto_sqlite3, "~> 0.7.5"},

      # Operations layer

      # testing
      {:floki, ">= 0.30.0", only: :test},

      # email
      {:swoosh, "~> 1.3"},

      # monitoring
      {:phoenix_live_dashboard, "~> 0.6", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  # Somewhat analogous to the "scripts" section of a package.json
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end

  # note that this is the actual configuration entrypoint, and calls the above (and below)
  # if you have a desire to refactor agressively, you can change up the structure - as long as this still
  # points to the right places.
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

  # Well ... that and this.
  def application do
    [
      mod: {WhatWhereWhen.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
