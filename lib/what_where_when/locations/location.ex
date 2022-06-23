defmodule WhatWhereWhen.Locations.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locations" do
    field :type, Ecto.Enum, values: [camp: 1, event: 2, infra: 3]

    field :lat, :decimal
    field :lng, :decimal
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:type, :lat, :lng])
    |> validate_required([:type, :lat, :lng])
  end
end
