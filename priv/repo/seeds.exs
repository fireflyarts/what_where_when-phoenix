require Logger

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

seeds_people_file = Path.expand("../seeds_people.exs", __ENV__.file)
seeds_camps_file = Path.expand("../seeds_camps.exs", __ENV__.file)

if File.exists?(seeds_people_file) do
  {[%{email: _e, id_name: _n} | _more_like_that] = people, _} = Code.eval_file(seeds_people_file)

  for person <- people, do: WhatWhereWhen.People.preregister_person(person)
else
  Logger.error("priv/repo/seeds_people.exs does not exist")
end

if File.exists?(seeds_camps_file) do
  {[%{name: _e, contact_email: _n} | _more_like_that] = camps, _} =
    Code.eval_file(seeds_camps_file)

  for camp <- camps, do: WhatWhereWhen.ThemeCamps.create_camp(camp)
else
  Logger.error("priv/repo/seeds_camps.exs does not exist")
end
