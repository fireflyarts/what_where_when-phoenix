defmodule WhatWhereWhenWeb.LocationController do
  use WhatWhereWhenWeb, :controller

  alias WhatWhereWhen.Locations

  def index(conn, _params) do
    locations = Locations.list_locations()
    render(conn, "index.html", locations: locations)
  end
end
