defmodule WhatWhereWhen.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias WhatWhereWhen.Repo

  alias WhatWhereWhen.Events.Event
  alias WhatWhereWhen.Events.Category
  alias WhatWhereWhen.People.Person

  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  def as_json(event_or_events, action \\ :show)

  def as_json(events, action) when is_list(events) do
    "[" <>
      (events
       |> Enum.map(&as_json(&1, action))
       |> Enum.join(",")) <>
      "]"
  end

  @doc """
  Inject url param for given action into json encoding
  ~lisp style for probably unnecessary performance (w/ Erlang/Elixir's cons-cell lists)
  """
  def as_json(%Event{id: id} = e, action)
      when action == :show or action == :edit do
    # remove the trailing },
    [?} | first_part_reversed] = Jason.encode_to_iodata!(e) |> :lists.reverse()
    first_part = :lists.reverse(first_part_reversed)

    [
      first_part,
      ~c[,"url": "],
      WhatWhereWhenWeb.Router.Helpers.event_path(WhatWhereWhenWeb.Endpoint, action, id),
      ?",
      ?}
    ]
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id),
    do:
      Repo.get!(Event, id)
      |> Repo.preload(:location)
      |> Repo.preload(:category)
      |> Repo.preload(:owning_person)
      |> Repo.preload(:owning_camp)

  def get_owned_by_person!(%Person{id: person_id}) do
    Repo.all(from e in Event, where: e.owning_person_id == ^person_id)
  end

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> handle_location(attrs)
    |> Repo.insert()
  end

  defp handle_location(cs, %{location_id: lid} = attrs) when lid != nil do
    Event.existing_location_changeset(cs, attrs)
  end

  defp handle_location(cs, %{location: %{type: :event, lat: _lat, lng: _lng}} = attrs) do
    Event.new_location_changeset(cs, attrs)
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end
end

#  Ecto.Changeset.traverse_errors(cs, fn
#    {"too low for category", opts} ->
#      "Cannot create a less-restricted event (#{Ecto.Changeset.get_field(cs, :minimum_age)}+) in category \"#{opts[:category_name]}\", because it's [#{opts[:number]}+]\". Please restrict more or move to different category."

#    {msg, _opts} ->
#      msg
#  end)}
