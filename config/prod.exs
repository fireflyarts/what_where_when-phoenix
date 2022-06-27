import Config

# META: this config is _static_ after final compilation. So a lot of stuff
# you might expect to find in here is actually
# over in config/runtime.exs (in the `if config_env() == :prod` block)

# === Frontend/View layer ===
# include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built but
# before starting the production server.
config :what_where_when, WhatWhereWhenWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json"

# === Routing/auth/controller layer ===

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :what_where_when, WhatWhereWhenWeb.Endpoint,
#       ...,
#       url: [host: "example.com", port: 443],
#       https: [
#         ...,
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :what_where_when, WhatWhereWhenWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# === DB/Data Layer ===

# === "Externalities" layer ===

config :sentry,
  dsn: "https://b95a7d648c3e4eff914c31717614fcb8@o1300142.ingest.sentry.io/6534193",
  environment_name: :prod,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  tags: %{
    env: "production"
  },
  included_environments: [:prod]

# === "VM layer" ===

# Do not print debug messages in production
config :logger, level: :info
