defmodule WhatWhereWhenWeb.EventCategoryController do
  use WhatWhereWhenWeb, :controller

  alias WhatWhereWhen.Events

  def index(conn, _params) do
    categories = Events.list_categories()
    render(conn, "index.html", categories: categories)
  end

  # def show(conn, %{"id" => id}) do
  #   camp = ThemeCamps.get_camp_with_members!(id)
  #   render(conn, "show.html", camp: camp)
  # end
end
