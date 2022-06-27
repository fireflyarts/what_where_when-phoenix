#!/usr/bin/env mix run

keys_to_ignore = MapSet.new([:__struct__, :id, :owning_person, :owning_camp, :location_id, :__meta__, :category, :inserted_at, :updated_at])
keys_to_compare = Map.keys(%WhatWhereWhen.Events.Event{}) |> Enum.reject(&(MapSet.member?(keys_to_ignore, &1)))

reduce_to_interesting = fn e ->
  e
  |> Map.take(keys_to_compare)
  |> Map.update(:location, nil, &Map.take(&1, [:description, :lat, :lng]))
end

dupes = WhatWhereWhen.Events.list_events |> WhatWhereWhen.Repo.preload(:location) |> Enum.group_by(&{&1.name, &1.start_date}) |> Enum.filter(&(length(elem(&1, 1)) > 1))

for {{name, date}, copies} <- dupes do
  IO.puts(name)
  IO.puts("")

  copies = copies |> Enum.sort_by(&(&1.updated_at), :desc)
  [newest | older ] = copies

  IO.puts("Newest from #{newest.updated_at}")

  newest = reduce_to_interesting.(newest)

  IO.puts("Checking equality:")
  try do
    for copy <- older do
      IO.write(copy.updated_at)
      IO.write(': ')
      case MapDiff.diff(newest, reduce_to_interesting.(copy)) do
        %{changed: :equal} -> IO.puts("✅")
        o ->
          IO.puts("❌ The following things were changed:")
          IO.inspect(Map.take(o, [:added, :removed]))

          case IO.gets("Should we still delete this older version [yN]?") do
            "y\n" -> true
            "Y\n" -> true
            _ -> throw :dont_clean
          end
      end
    end

    IO.puts("Doing cleanup:")
    for redundant <- older do
      WhatWhereWhen.Repo.delete!(redundant)
    end
  catch
    :dont_clean -> true
  end



  IO.puts("-----------------")
end
