defmodule WhatWhereWhen.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string, null: false
      add :description, :text, null: false

      add :start_date, :date, null: false
      add :start_time, :naive_datetime, null: true

      add :category_id, references(:event_categories, on_delete: :nothing)
      add :minimum_age, :integer, default: 0

      add(:owning_person_id, references(:people), null: true)

      add(:owning_camp_id, references(:camps),
        null: true,
        check: %{
          name: "owning_person_xor_camp",
          expr:
            "((owning_person_id NOTNULL) AND (owning_camp_id ISNULL)) OR ((owning_camp_id NOTNULL) AND (owning_person_id ISNULL))"
        }
      )

      timestamps()
    end

    create index(:events, [:start_date])
    create index(:events, [:start_time])
    create index(:events, [:category_id])
  end
end
