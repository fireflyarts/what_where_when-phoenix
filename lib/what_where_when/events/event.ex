defmodule WhatWhereWhen.Events.Event do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias WhatWhereWhen.Events.Category
  alias WhatWhereWhen.People.Person
  alias WhatWhereWhen.ThemeCamps.Camp
  alias WhatWhereWhen.Locations.Location
  alias WhatWhereWhen.Repo

  schema "events" do
    field :name, :string
    field :description, :string

    field :start_date, :date
    field :start_time, :naive_datetime

    field :sober_friendly, Ecto.Enum, values: [no: 0, options: 1, yes: 2]
    belongs_to :category, WhatWhereWhen.Events.Category
    field :minimum_age, :integer, default: 0

    belongs_to :owning_person, Person
    belongs_to :owning_camp, Camp

    belongs_to :location, Location

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    cs =
      event
      |> cast(attrs, [
        :name,
        :description,
        :start_date,
        :category_id,
        :minimum_age,
        :sober_friendly,
        :owning_person_id,
        :owning_camp_id
      ])
      |> validate_required([
        :name,
        :description,
        :start_date,
        :minimum_age,
        :sober_friendly
      ])
      |> assoc_constraint(:category)
      |> check_constraint(:owning_person_id, name: "owning_person_xor_camp")
      |> check_constraint(:owning_camp_id, name: "owning_person_xor_camp")
      |> validate_age_coherence()

    if get_field(cs, :sober_friendly) == :no && get_field(cs, :minimum_age) < 18 do
      add_error(
        cs,
        :sober_friendly,
        "Call me old fashioned, but you should probably have some sober options for the straight-edge kids"
      )
    else
      cs
    end
  end

  def existing_location_changeset(cs, attrs) do
    cs
    |> cast(attrs, [:location_id])
    |> assoc_constraint(:location)
  end

  def new_location_changeset(cs, attrs) do
    cs
    |> cast(attrs, [])
    |> cast_assoc(:location, required: true, with: &Location.changeset/2)
    |> validate_change(:location, fn
      :location, %Location{} ->
        []

      :location, %Ecto.Changeset{valid?: false} ->
        [location: "Must be specified. Please click to place"]

      :location, %Ecto.Changeset{valid?: true} ->
        []
    end)
  end

  # we'll put off validating into the association until the basics are passing - or at least cat is set
  defp validate_age_coherence(%{valid?: false, data: %{category_id: nil}, changes: changed} = cs)
       when not is_map_key(changed, :category_id),
       do: cs

  defp validate_age_coherence(%Ecto.Changeset{changes: changed, data: %{category: cat}} = cs)
       when is_map_key(changed, :category_id) or is_struct(cat, Ecto.Association.NotLoaded) do
    cat_id = fetch_field!(cs, :category_id)
    {cat_name, cat_age} = category_name_and_minimum_age!(cat_id)

    if get_field(cs, :minimum_age) < cat_age do
      add_category_minimum_age_error(cs, %{id: cat_id, name: cat_name, minimum_age: cat_age})
    else
      cs
    end
  end

  defp validate_age_coherence(cs) do
    event_age = get_field(cs, :minimum_age)
    category = get_field(cs, :category)

    if event_age < category.id do
      add_category_minimum_age_error(cs, category)
    else
      cs
    end
  end

  defp add_category_minimum_age_error(cs, %{id: cat_id, name: cat_name, minimum_age: cat_age}) do
    add_error(cs, :minimum_age, "too low for category",
      validation: :number,
      kind: :greater_than_or_equal_to,
      number: cat_age,
      category_name: cat_name,
      category_id: cat_id
    )
  end

  defp category_name_and_minimum_age!(category_id) do
    Repo.one!(from c in Category, where: c.id == ^category_id, select: {c.name, c.minimum_age})
  end
end

defimpl Jason.Encoder, for: WhatWhereWhen.Events.Event do
  def encode(
        %WhatWhereWhen.Events.Event{id: id, start_date: sd, start_time: st, name: n},
        opts
      ) do
    # hewing to the https://fullcalendar.io/docs/event-object

    allDay = st == nil

    Jason.Encode.map(
      %{
        "id" => Jason.encode!(id),
        "title" => n,
        "allDay" => allDay,
        "start" => if(allDay, do: Date.to_iso8601(sd), else: NaiveDateTime.to_iso8601(st))
        # "end" =>
        #   if(allDay,
        #     do: Date.to_iso8601(sd),
        #     else: Timex.add(st, Timex.Duration.from_hours(1)) |> NaiveDateTime.to_iso8601()
        #   )
      },
      opts
    )
  end
end
