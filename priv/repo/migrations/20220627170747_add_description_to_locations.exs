defmodule WhatWhereWhen.Repo.Migrations.AddDescriptionToLocations do
  use Ecto.Migration

  def change do
    alter table(:locations) do
      add :description, :string
    end
  end
end
