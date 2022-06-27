defmodule WhatWhereWhenWeb.PersonController do
  use WhatWhereWhenWeb, :controller
  alias WhatWhereWhen.Events

  def show(%Plug.Conn{assigns: %{current_person: person}} = conn, _params) when person != nil do
    events = Events.get_owned_by_person!(person)

    render(conn, "show.html", events: events)
  end

  def show(conn, params) do
    conn
    |> put_view(WhatWhereWhenWeb.PersonSessionView)
    |> WhatWhereWhenWeb.PersonSessionController.new(params)
  end
end
