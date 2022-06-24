defmodule WhatWhereWhenWeb.LocationControllerTest do
  use WhatWhereWhenWeb.ConnCase

  describe "index" do
    test "lists all locations", %{conn: conn} do
      conn = get(conn, Routes.location_path(conn, :index))
      assert html_response(conn, 200) =~ "<div id=\"map\""
    end
  end
end
