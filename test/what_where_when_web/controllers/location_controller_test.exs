defmodule WhatWhereWhenWeb.LocationControllerTest do
  use WhatWhereWhenWeb.ConnCase

  import WhatWhereWhen.LocationsFixtures

  @create_attrs %{latitude: "120.5", longitude: "120.5"}
  @update_attrs %{latitude: "456.7", longitude: "456.7"}
  @invalid_attrs %{latitude: nil, longitude: nil}

  describe "index" do
    test "lists all locations", %{conn: conn} do
      conn = get(conn, Routes.location_path(conn, :index))
      assert html_response(conn, 200) =~ "<div id=\"map\""
    end
  end
end
