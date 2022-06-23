defmodule WhatWhereWhenWeb.EventController do
  use WhatWhereWhenWeb, :controller

  alias WhatWhereWhen.Events
  alias WhatWhereWhen.Events.Event

  import Ecto.Changeset

  def new(conn, _params) do
    cs = Events.change_event(%Event{})
    cats = Events.list_categories()

    render(conn, "new.html", changeset: cs, categories: cats)
  end

  def show(conn, _event), do: nil

  def create(conn, %{"event" => event_params}) do
    event_params =
      event_params
      |> Map.put("location", %{
        type: :event,
        lat: event_params["location_lat"],
        lng: event_params["location_lng"]
      })

    IO.inspect(event_params)

    cs = Event.changeset(%Event{}, event_params)

    cs =
      case event_params["owner_type"] do
        nil ->
          add_error(cs, :owner_type, "Event needs to be (at least listed as) hosted by somebody",
            validation: :required
          )

        "person" ->
          put_change(cs, :owning_person_id, conn.assigns.current_person.id)

        "camp" ->
          put_change(cs, :owning_camp_id, conn.assigns.current_person.camp_id)
      end

    cs =
      cond do
        event_params["all_day"] == "false" && event_params["start_time"] == "" ->
          add_error(cs, :start_time, "Please mark as all day or specify start time")

        event_params["all_day"] == "true" ->
          put_change(cs, :start_time, nil)

        true ->
          start_date = event_params["start_date"]
          start_time = event_params["start_time"]

          case Timex.parse("#{start_date} #{start_time}", "{YYYY}-{M}-{D} {h24}:{m}") do
            {:ok, dt} ->
              put_change(cs, :start_time, dt)

            {:error, t} ->
              add_error(cs, :start_time, "Bad time: #{t}", format: :time)
          end
      end

    case WhatWhereWhen.Repo.insert(cs) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        render(conn, "new.html", changeset: changeset, categories: Events.list_categories())
    end
  end
end
