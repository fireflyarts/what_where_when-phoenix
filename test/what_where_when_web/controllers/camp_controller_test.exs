defmodule WhatWhereWhenWeb.CampControllerTest do
  use WhatWhereWhenWeb.ConnCase

  import WhatWhereWhen.ThemeCampsFixtures

  @update_attrs %{}
  @invalid_attrs %{name: nil}

  describe "index" do
    test "lists all camps", %{conn: conn} do
      conn = get(conn, Routes.camp_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Camps"
    end
  end

  describe "edit camp" do
    setup [:create_camp]

    test "renders form for editing chosen camp", %{conn: conn, camp: camp} do
      conn = get(conn, Routes.camp_path(conn, :edit, camp))
      assert html_response(conn, 200) =~ "Edit Camp"
    end
  end

  describe "update camp" do
    setup [:create_camp]

    test "redirects when data is valid", %{conn: conn, camp: camp} do
      conn = put(conn, Routes.camp_path(conn, :update, camp), camp: @update_attrs)
      assert redirected_to(conn) == Routes.camp_path(conn, :show, camp)

      conn = get(conn, Routes.camp_path(conn, :show, camp))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, camp: camp} do
      conn = put(conn, Routes.camp_path(conn, :update, camp), camp: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Camp"
    end
  end

  describe "delete camp" do
    setup [:create_camp]

    test "deletes chosen camp", %{conn: conn, camp: camp} do
      conn = delete(conn, Routes.camp_path(conn, :delete, camp))
      assert redirected_to(conn) == Routes.camp_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.camp_path(conn, :show, camp))
      end
    end
  end

  defp create_camp(_) do
    camp = camp_fixture()
    %{camp: camp}
  end
end
