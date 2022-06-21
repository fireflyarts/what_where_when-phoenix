defmodule WhatWhereWhen.Repo.Migrations.CreatePeopleAuthTables do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :id_name, :string, null: false
      add :burn_name, :string, null: true
      add :email, :string, null: false, collate: :nocase
      add :hashed_password, :string, null: true
      add :confirmed_at, :naive_datetime
      timestamps()
    end

    create unique_index(:people, [:email])

    create table(:people_tokens) do
      add :person_id, references(:people, on_delete: :delete_all), null: false
      add :token, :binary, null: false, size: 32
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:people_tokens, [:person_id])
    create unique_index(:people_tokens, [:context, :token])
  end
end
