defmodule WhatWhereWhen.LocationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WhatWhereWhen.Locations` context.
  """

  @doc """
  Generate a location.
  """
  def location_fixture(attrs \\ %{}) do
    {:ok, location} =
      attrs
      |> Enum.into(%{
        type: :event,
        lat: "120.5",
        lng: "120.5"
      })
      |> WhatWhereWhen.Locations.create_location()

    location
  end
end
