defmodule WhatWhereWhen.ThemeCampsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WhatWhereWhen.ThemeCamps` context.
  """

  @doc """
  Generate a camp.
  """
  def camp_fixture(attrs \\ %{}) do
    owner = attrs[:owner] || WhatWhereWhen.PeopleFixtures.person_fixture()

    {:ok, camp} =
      attrs
      |> Enum.into(%{
        name: "some name",
        contact_email: owner.email
      })
      |> WhatWhereWhen.ThemeCamps.create_camp()

    camp
  end
end
