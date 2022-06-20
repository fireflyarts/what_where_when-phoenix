# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     WhatWhereWhen.Repo.insert!(%WhatWhereWhen.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

all_ages_categories = [
  {"Watch!", "🎭"},
  {"Learn!", "🧑‍🏫"},
  {"Eat!", "🍲"},
  {"Drink!", "🫖"},
  {"Play! (games)", "🎲"},
  {"Play! (sports)", "🏸"}
]

adult_categories = [
  {"Learn!", "🤯", 18},
  {"Play!", "😘", 18},
  {"Drink!", "🍹", 21}
]

categories =
  all_ages_categories
  |> Enum.map(fn {n, e} -> {n, e, 0} end)
  |> Enum.concat(adult_categories)
  |> Enum.map(fn {n, e, ma} ->
    %{name: n, emoji: e, minimum_age: ma}
  end)

for cat <- categories do
  {:ok, _category} = WhatWhereWhen.Events.create_category(cat)
end
