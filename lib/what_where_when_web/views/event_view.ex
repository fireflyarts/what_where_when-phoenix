defmodule WhatWhereWhenWeb.EventView do
  use WhatWhereWhenWeb, :view

  alias WhatWhereWhen.Events
  alias WhatWhereWhenWeb.EventCategoryView

  def render("index.html", assigns) do
    render("_calendar.html", Map.put(assigns, :action, :show))
  end
end
