defmodule WhatWhereWhen.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string, null: false
      add :description, :text, null: false

      add :start_date, :date, null: false
      # add :end_date, :date, null: false

      add :start_time, :naive_datetime, null: true
      # add :end_time, :naive_datetime, null: true

      add :category_id, references(:event_categories, on_delete: :nothing)
      add :minimum_age, :integer, default: 0

      timestamps()
    end

    create index(:events, [:start_date])
    create index(:events, [:start_time])
    create index(:events, [:category_id])
  end
end
