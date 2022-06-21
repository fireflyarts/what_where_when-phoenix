defmodule WhatWhereWhen.EventsTest do
  use WhatWhereWhen.DataCase

  alias WhatWhereWhen.Events
  import WhatWhereWhen.EventsFixtures

  describe "creating any event" do
    test "requires a name" do
      assert {:error, cs} = event_fixture_tagged(%{})
      assert elem(cs.errors[:name], 1) == [validation: :required]
    end

    test "requires a description" do
      assert {:error, cs} = event_fixture_tagged(%{})
      assert elem(cs.errors[:description], 1) == [validation: :required]
    end

    test "requires a start date" do
      assert {:error, cs} = event_fixture_tagged(%{start_date: nil})
      assert {_, [validation: :required] }  = cs.errors[:start_date]
    end
  end

  describe "within in an all-ages category," do
    setup :category

    test "can create an unrestricted event", ctx do
      assert {:ok, _e} =
               event_fixture_tagged(%{
                 name: "All in All",
                 description: "All ages event in all ages category",

                 category_id: ctx[:category].id
               })
    end

    test "can create a more restricted event", ctx do
      assert {:ok, _e} =
               event_fixture_tagged(%{
                 name: "10+ in All",
                 description: "somewhat restricted event in all ages category",

                 category_id: ctx[:category].id,
                 minimum_age: 10
               })
    end
  end

  describe "within an age-restricted category," do
    setup :category_18_plus

    test "can can create an equally restricted event", ctx do
      assert {:ok, _e} =
               event_fixture_tagged(%{
                 name: "18+ in 18+",
                 description: "18+ event in a 18+ category",

                 category_id: ctx[:category_18_plus].id,
                 minimum_age: 18
               })
    end

    test "can create a more restricted event", ctx do
      assert {:ok, _e} =
               event_fixture_tagged(%{
                 name: "21+ in 18+",
                 description: "21+ event in a 18+ category",

                 category_id: ctx[:category_18_plus].id,
                 minimum_age: 21
               })
    end

    test "can NOT create an unrestricted event", ctx do
      assert {:error, cs} =
               event_fixture_tagged(%{
                 name: "all-ages in 18+",
                 description: "21+ event in a 18+ category",

                 category_id: ctx[:category_18_plus].id
               })

      assert elem(cs.errors[:minimum_age], 1) ==
               [
                 validation: :number,
                 kind: :greater_than_or_equal_to,
                 number: 18,
                 category_name: ctx[:category_18_plus].name,
                 category_id: ctx[:category_18_plus].id
               ]
    end

    test "can NOT create a LESS restricted event", ctx do
      assert {:error, cs} =
               event_fixture_tagged(%{
                 name: "all-ages in 18+",
                 description: "21+ event in a 18+ category",

                 category_id: ctx[:category_18_plus].id,
                 minimum_age: 16
               })

      assert elem(cs.errors[:minimum_age], 1) ==
               [
                 validation: :number,
                 kind: :greater_than_or_equal_to,
                 number: 18,
                 category_name: ctx[:category_18_plus].name,
                 category_id: ctx[:category_18_plus].id
               ]
    end
  end

  defp ok!({:ok, a}), do: a

  defp category(_ctx),
    do: [category: Events.create_category(%{name: "All-ages", emoji: "👶"}) |> ok!()]

  defp category_18_plus(_ctx),
    do: [
      category_18_plus:
        Events.create_category(%{name: "Adults", emoji: "🔞", minimum_age: 18}) |> ok!()
    ]
end
