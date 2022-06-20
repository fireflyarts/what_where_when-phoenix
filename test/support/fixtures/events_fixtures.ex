defmodule WhatWhereWhen.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WhatWhereWhen.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{})
      |> WhatWhereWhen.Events.create_event()

    event
  end
end
