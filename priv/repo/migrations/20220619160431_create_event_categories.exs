defmodule WhatWhereWhen.Repo.Migrations.CreateEventCategories do
  use Ecto.Migration
  import Ecto.Migration

  def change do
    create table(:event_categories) do
      add :name, :string, null: false
      add :emoji, :string, null: false
      add :minimum_age, :integer, default: 0
    end

    create unique_index(:event_categories, [:name, :minimum_age])
  end
end
