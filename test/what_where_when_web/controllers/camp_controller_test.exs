defmodule WhatWhereWhenWeb.CampControllerTest do
  use WhatWhereWhenWeb.ConnCase

  setup :register_and_log_in_person

  describe "index" do
    test "lists all camps", %{conn: conn} do
      conn = get(conn, Routes.camp_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Camps"
    end
  end
end
