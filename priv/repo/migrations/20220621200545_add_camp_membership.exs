defmodule WhatWhereWhen.Repo.Migrations.AddCampMembership do
  use Ecto.Migration
  import Ecto.Migration

  def change do
    alter table(:people) do
      add :camp_id, references(:camps), null: true
    end

    create index(:people, [:camp_id])
  end
end
