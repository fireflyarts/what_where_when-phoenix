defmodule WhatWhereWhenWeb.PageControllerTest do
  use WhatWhereWhenWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "2022 WhatWhereWhen!"
  end
end
