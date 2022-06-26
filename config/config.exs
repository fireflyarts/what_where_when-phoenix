import Config

# META: I have organized this file in frontend ("top of stack") to backend ("bottom of stack") order (like the mix.exs deps function)
# Insofar as configs are namespaced, their order should not matter much in practice (within a file, file load order will still determine e.g. per env overrides)

# === the outside the computer entirely layer ==

config :what_where_when, firefly_start_date: ~D[2022-06-29]
config :what_where_when, firefly_end_date: ~D[2022-07-04]

# === Frontend/View layer ===

# Configure esbuild for javascript management
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js js/map.tsx --bundle --target=es2017 --loader:.png=file --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind for overall css management
config :tailwind,
  version: "3.1.0",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# === Routing/auth/controller layer ===

# Configures the endpoint
config :what_where_when, WhatWhereWhenWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: WhatWhereWhenWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: WhatWhereWhen.PubSub,
  live_view: [signing_salt: "vylC2Nlp"]

# === API layer ===

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# === DB/Data Layer ==

config :what_where_when,
  ecto_repos: [WhatWhereWhen.Repo]

# === "Externalities" layer ===

# == "VM layer" ==

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# --------------------------------------------------------

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
