defmodule WhatWhereWhen.Repo.Migrations.CreateLocations do
  use Ecto.Migration
  import Ecto.Migration

  def change do
    create table(:locations) do
      add :type, :integer,
        check: %{
          name: "check_location_type",
          expr: "type = 1 OR type = 2 OR type = 3"
        }

      add :lat, :decimal
      add :lng, :decimal
    end

    execute(
      "INSERT INTO locations (type, lat, lng) VALUES (3, 1028.5330622016834, 972.9789309126893)",
      "DELETE FROM locations WHERE id = 1"
    )
  end
end
