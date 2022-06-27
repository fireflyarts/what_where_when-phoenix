defmodule WhatWhereWhenWeb.EventController do
  use WhatWhereWhenWeb, :controller

  alias WhatWhereWhen.Events
  alias WhatWhereWhen.Events.Event

  import Ecto.Changeset

  def index(conn, _) do
    events = Events.list_events()

    case get_format(conn) do
      "json" ->
        json(conn, events)

      _ ->
        render(conn, "index.html", events: events)
    end
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", event: Events.get_event!(id))
  end

  def new(conn, _params) do
    cs = Events.change_event(%Event{})
    cats = Events.list_categories()

    render(conn, "new.html", changeset: cs, categories: cats)
  end

  def edit(conn, %{"id" => id}) do
    e = Events.get_event!(id)

    if e.owning_person_id != conn.assigns.current_person.id do
      Plug.Conn.put_status(conn, :unauthorized)
    else
      render(conn, "edit.html",
        event: e,
        changeset: Event.changeset(e, %{}),
        categories: Events.list_categories()
      )
    end
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    e = Events.get_event!(id)

    if e.owning_person_id != conn.assigns.current_person.id do
      Plug.Conn.put_status(conn, :unauthorized)
    else
      cs = upsert(conn, e, event_params)

      case WhatWhereWhen.Repo.update(cs) do
        {:ok, event} ->
          conn
          |> put_flash(:info, "Event updated successfully.")
          |> redirect(to: Routes.event_path(conn, :show, event))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html",
            event: e,
            changeset: changeset,
            categories: Events.list_categories()
          )
      end
    end
  end

  def create(conn, %{"event" => event_params}) do
    cs = upsert(conn, %Event{}, event_params)

    case WhatWhereWhen.Repo.insert(cs) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          categories: Events.list_categories()
        )
    end
  end

  defp upsert(conn, start, event_params) do
    Event.changeset(start, event_params)
    |> handle_owner(conn, event_params["owner_type"])
    |> handle_date_and_maybe_time(Map.take(event_params, ~w[all_day start_date start_time]))
    |> handle_location(
      event_params["location_is_camp"],
      conn.assigns.current_person.camp,
      event_params["location"]
    )
  end

  defp handle_owner(cs, _conn, nil) do
    cs
    |> add_error(:owner_type, "Event needs to be (at least listed as) hosted by somebody",
      validation: :required
    )
  end

  defp handle_owner(cs, conn, "person") do
    cs
    |> put_change(:owning_person_id, conn.assigns.current_person.id)
  end

  defp handle_owner(cs, conn, "camp") do
    cs
    |> put_change(:owning_camp_id, conn.assigns.current_person.camp_id)
  end

  defp handle_date_and_maybe_time(cs, %{"all_day" => "true"}) do
    cs
    |> force_change(:start_time, nil)
  end

  defp handle_date_and_maybe_time(cs, %{"start_time" => ""}) do
    cs
    |> add_error(:start_time, "Please mark as all day or specify start time")
  end

  defp handle_date_and_maybe_time(cs, %{"start_date" => start_date, "start_time" => start_time}) do
    case Timex.parse("#{start_date} #{start_time}", "{YYYY}-{M}-{D} {h24}:{m}") do
      {:ok, dt} ->
        put_change(cs, :start_time, dt)

      {:error, t} ->
        add_error(cs, :start_time, "Bad time: #{t}", format: :time)
    end
  end

  # If we do know where a camp is located and the event is there, we jut go ahead
  # and point at the camp location in the locations table
  defp handle_location(cs, _location_is_camp = "true", %{location_id: location_id}, _latlng)
       when location_id != nil
       when not is_nil(location_id) do
    cs
    |> Event.existing_location_changeset(%{
      location_id: location_id
    })
  end

  # Alas, we don't necessarily have all the placement data, so we'll try to backfill by asking
  # the first time they try to host an event.
  #
  # We do this by first prompting to map to draw and hinting ourselves that its coming (with an new hidden field)
  defp handle_location(cs, "true", %{id: camp_id, location_id: nil}, %{"lat" => ""}) do
    cs
    |> add_error(:location, "Could you uh... remind me where that camp is?",
      camp_location_not_set: camp_id
    )
  end

  # And then if we get it back, we just set/update it inline of the process of assigning event to camp location
  defp handle_location(cs, "true", %{id: n_camp_id, location_id: nil} = camp, %{
         "is_for_camp" => camp_id,
         "lat" => lat,
         "lng" => lng
       }) do
    # this (also) doublechecks that the one submitted for is the same as the one of session user
    {^n_camp_id, _} = Integer.parse(camp_id)

    handle_location(
      cs,
      "true",
      WhatWhereWhen.ThemeCamps.update_location!(camp, %{
        location: %{type: :camp, lat: lat, lng: lng}
      }),
      nil
    )
  end

  defp handle_location(cs, _location_is_not, _camp, %{"description" => description} = params)
       when not is_map_key(params, "lat") do
    cs
    |> Event.new_location_changeset(%{location: %{type: :event, description: description}})
  end

  defp handle_location(cs, _location_is_not, _camp, %{
         "lat" => lat,
         "lng" => lng,
         "description" => description
       }) do
    cs
    |> Event.new_location_changeset(%{
      location: %{type: :event, lat: lat, lng: lng, description: description}
    })
  end

  defp handle_location(cs, _location_is_not, _camp, %{"lat" => lat, "lng" => lng}) do
    cs
    |> Event.new_location_changeset(%{location: %{type: :event, lat: lat, lng: lng}})
  end
end
