defmodule WhatWhereWhen.Locations.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locations" do
    field :type, Ecto.Enum, values: [camp: 1, event: 2, infra: 3]

    field :lat, :decimal
    field :lng, :decimal
    field :description, :string
  end

  @doc false
  def changeset(location, attrs) do
    cs =
      location
      |> cast(attrs, [:type, :lat, :lng, :description])
      |> validate_required([:type])

    case get_field(cs, :description) do
      x when x == "" or is_nil(x) ->
        cs |> validate_required([:lat, :lng])

      _ ->
        cs
    end
  end
end
