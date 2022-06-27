defmodule WhatWhereWhenWeb.EventView do
  use WhatWhereWhenWeb, :view

  alias WhatWhereWhen.Events
  alias WhatWhereWhen.Events.Event
  alias WhatWhereWhenWeb.EventCategoryView

  def render("index.html", assigns) do
    render(
      "_calendar.html",
      assigns
      |> Map.put(:route, :event_path)
      |> Map.put(:action, :show)
    )
  end
end
