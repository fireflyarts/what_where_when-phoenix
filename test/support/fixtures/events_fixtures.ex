defmodule WhatWhereWhen.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WhatWhereWhen.Events` context.
  """

  @doc """
  Generate a event. Include {:ok, } or {:error, }
  """
  def event_fixture_tagged(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      owning_person_id: WhatWhereWhen.PeopleFixtures.person_fixture().id,
      start_date: Date.utc_today(),
      location: WhatWhereWhen.LocationsFixtures.location_fixture() |> Map.from_struct(),
      sober_friendly: :yes
    })
    |> WhatWhereWhen.Events.create_event()
  end
end
