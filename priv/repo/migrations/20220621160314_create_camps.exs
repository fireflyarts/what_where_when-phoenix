defmodule WhatWhereWhen.Repo.Migrations.CreateCamps do
  use Ecto.Migration

  def change do
    create table(:camps) do
      add :emoji, :string
      add :name, :string, null: false

      add :primary_contact_id, references(:people, on_delete: :nothing), null: false
    end

    create index(:camps, [:primary_contact_id])
  end
end
