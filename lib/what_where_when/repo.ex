defmodule WhatWhereWhen.Repo do
  use Ecto.Repo,
    otp_app: :what_where_when,
    adapter: Ecto.Adapters.SQLite3
end
