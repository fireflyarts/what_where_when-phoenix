import Config

######## ENV VAR INPUTS ######

# If set, server will allow connections from other devices on the local network
# so you can test with a phone or whatever. (i.e. bind 0.0.0.0 vs 127.0.0.1)
wwwphx_allow_external_connections = System.get_env("WWWPHX_ALLOW_EXTERNAL_CONNECTIONS")

# === Frontend/View layer ===
# Define sidecars to be invoked (via their elixir wrappers) / integrated
# when we run `mix phx.server`

frontend_watchers = [
  esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
  tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
]

# Watch static and templates for browser reloading.
config :what_where_when, WhatWhereWhenWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"lib/what_where_when_web/(live|views)/.*(ex)$",
      ~r"lib/what_where_when_web/templates/.*(eex)$"
    ]
  ]

# === Routing/auth/controller layer ==

# For development, we disable any cache and enable
# debugging and code reloading.
config :what_where_when, WhatWhereWhenWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [
    ip: if(wwwphx_allow_external_connections, do: {0, 0, 0, 0}, else: {127, 0, 0, 1}),
    port: 4000
  ],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "VE2KgxYKnYO/mM6Kz/gsTL8IZjGenOy7nT32yTB1F+UWb0ljG3Ax/mmmeHPikpmm",
  watchers: frontend_watchers

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# == DB/Data Layer =

config :what_where_when, WhatWhereWhen.Repo,
  username: "postgres",
  database: "what_where_when_dev",
  hostname: "localhost",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# == "VM layer" ==

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"
