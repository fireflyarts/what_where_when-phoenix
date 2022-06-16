defmodule WhatWhereWhenWeb.PageController do
  use WhatWhereWhenWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
