defmodule WhatWhereWhen.Events.Event do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias WhatWhereWhen.Events.Category
  alias WhatWhereWhen.People.Person
  alias WhatWhereWhen.ThemeCamps.Camp
  alias WhatWhereWhen.Repo

  schema "events" do
    field :name, :string
    field :description, :string

    field :start_date, :date
    field :start_time, :naive_datetime

    belongs_to :category, WhatWhereWhen.Events.Category
    field :minimum_age, :integer, default: 0

    belongs_to :owning_person, Person
    belongs_to :owning_camp, Camp

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [
      :name,
      :description,
      :start_date,
      :start_time,
      :category_id,
      :minimum_age,
      :owning_person_id,
      :owning_camp_id
    ])
    |> validate_required([:name, :description, :start_date, :minimum_age])
    |> assoc_constraint(:category)
    |> check_constraint(:owning_person_id, name: "owning_person_xor_camp")
    |> check_constraint(:owning_camp_id, name: "owning_person_xor_camp")
    |> validate_age_coherence()
  end

  # we'll put off validating into the association until the basics are passing
  defp validate_age_coherence(%{valid?: false} = cs), do: cs

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
