defmodule WhatWhereWhen.ThemeCamps.Camp do
  use Ecto.Schema
  import Ecto.Schema
  import Ecto.Changeset

  alias WhatWhereWhen.People.Person
  alias WhatWhereWhen.Locations.Location

  schema "camps" do
    field :emoji, Util.Ecto.Emoji
    field :name, :string

    belongs_to :primary_contact, Person
    has_many :members, Person

    belongs_to :location, Location
  end

  @doc false
  def changeset(camp, attrs) do
    camp
    |> cast(attrs, [:name, :primary_contact_id])
    |> validate_required([:name, :primary_contact_id])
    |> assoc_constraint(:primary_contact)
  end

  def location_changeset(camp, attrs) do
    camp
    |> WhatWhereWhen.Repo.preload(:location)
    |> cast(attrs, [])
    |> cast_assoc(:location, with: &Location.changeset/2)
    |> validate_change(:location, fn
      :location, %Ecto.Changeset{valid?: false} ->
        [location: "Must be specified. Please click to place"]

      :location, %Ecto.Changeset{valid?: true} ->
        []
    end)
  end
end
