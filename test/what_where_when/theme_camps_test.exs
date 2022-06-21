defmodule WhatWhereWhen.ThemeCampsTest do
  use WhatWhereWhen.DataCase

  alias WhatWhereWhen.ThemeCamps

  describe "camps" do
    alias WhatWhereWhen.ThemeCamps.Camp

    import WhatWhereWhen.ThemeCampsFixtures
    import WhatWhereWhen.PeopleFixtures

    def invalid_attrs, do: %{name: nil, sound_camp: nil, contact_email: person_fixture().email}

    test "list_camps/0 returns all camps" do
      camp = camp_fixture()
      assert ThemeCamps.list_camps() == [camp]
    end

    test "get_camp!/1 returns the camp with given id" do
      camp = camp_fixture()
      assert ThemeCamps.get_camp!(camp.id) == camp
    end

    test "create_camp/1 with valid data creates a camp" do
      valid_attrs = %{name: "some name", contact_email: person_fixture().email}

      assert {:ok, %Camp{} = camp} = ThemeCamps.create_camp(valid_attrs)
      assert camp.name == "some name"
    end

    test "create_camp/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ThemeCamps.create_camp(invalid_attrs)
    end

    test "update_camp/2 with valid data updates the camp" do
      camp = camp_fixture()
      update_attrs = %{name: "some updated name", sound_camp: false}

      assert {:ok, %Camp{} = camp} = ThemeCamps.update_camp(camp, update_attrs)
      assert camp.name == "some updated name"
    end

    test "update_camp/2 with invalid data returns error changeset" do
      camp = camp_fixture()
      assert {:error, %Ecto.Changeset{}} = ThemeCamps.update_camp(camp, invalid_attrs)
      assert camp == ThemeCamps.get_camp!(camp.id)
    end

    test "delete_camp/1 deletes the camp" do
      camp = camp_fixture()
      assert {:ok, %Camp{}} = ThemeCamps.delete_camp(camp)
      assert_raise Ecto.NoResultsError, fn -> ThemeCamps.get_camp!(camp.id) end
    end

    test "change_camp/1 returns a camp changeset" do
      camp = camp_fixture()
      assert %Ecto.Changeset{} = ThemeCamps.change_camp(camp)
    end
  end
end
