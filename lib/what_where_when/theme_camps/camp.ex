defmodule WhatWhereWhen.ThemeCamps.Camp do
  use Ecto.Schema
  import Ecto.Schema
  import Ecto.Changeset

  alias WhatWhereWhen.People.Person

  schema "camps" do
    field :emoji, Util.Ecto.Emoji
    field :name, :string

    belongs_to :primary_contact, Person
    has_many :members, Person
  end

  @doc false
  def changeset(camp, attrs) do
    camp
    |> cast(attrs, [:name, :primary_contact_id])
    |> validate_required([:name, :primary_contact_id])
    |> assoc_constraint(:primary_contact)
  end
end
