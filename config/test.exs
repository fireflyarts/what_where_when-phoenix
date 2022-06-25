import Config

config :what_where_when,
  ticketing_key: "Not the real thing, but tests just want not null"

# === Frontend/View layer ===

# currently there is nothing special done for testing
# but if we want to rig ~jest or browsershots or whatever
# ¯\_(ツ)_/¯

# === Routing/auth/controller layer ===

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :what_where_when, WhatWhereWhenWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "FC9LvzteCe4p/GbBAcppqFeRYbdoU8FHM79gsXS+FYiL6e7h0H6eXyONdQMmH2m7",
  server: false

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# === API layer ===

# == DB/Data Layer ==

# For better or worse, run accross to sqlite so as to not have to contend with postgres
# inside github actions
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :what_where_when, WhatWhereWhen.Repo,
  username: "postgres",
  password: "postgres",
  hostname: if(System.get_env("CI"), do: "postgres", else: "localhost"),
  database: "what_where_when_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# === "Externalities" layer ===

# In test we don't send emails.
config :what_where_when, WhatWhereWhen.Mailer, adapter: Swoosh.Adapters.Test

# === "VM layer" ===

# Print only warnings and errors during test
config :logger, level: :warn
