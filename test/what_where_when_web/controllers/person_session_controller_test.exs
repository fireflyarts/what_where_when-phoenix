defmodule WhatWhereWhenWeb.PersonSessionControllerTest do
  use WhatWhereWhenWeb.ConnCase

  import WhatWhereWhen.PeopleFixtures

  setup do
    %{person: person_fixture()}
  end

  describe "GET /who/me" do
    test "redirects if already logged in", %{conn: conn, person: person} do
      conn = conn |> log_in_person(person) |> get(Routes.person_session_path(conn, :new))
      assert redirected_to(conn) == "/"
    end

    test "logs the person in", %{conn: conn, person: person} do
      conn =
        get(conn, Routes.person_session_path(conn, :create), %{
          "person" => %{"email" => person.email}
        })

      assert get_session(conn, :person_token)
      assert redirected_to(conn) == "/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ "#{person.email}"
    end

    test "logs the person in with return to", %{conn: conn, person: person} do
      conn =
        conn
        |> init_test_session(person_return_to: "/foo/bar")
        |> get(Routes.person_session_path(conn, :create), %{
          "person" => %{
            "email" => person.email
          }
        })

      assert redirected_to(conn) == "/foo/bar"
    end
  end

  describe "DELETE /people/log_out" do
    test "logs the person out", %{conn: conn, person: person} do
      conn = conn |> log_in_person(person) |> delete(Routes.person_session_path(conn, :delete))
      assert redirected_to(conn) == "/"
      refute get_session(conn, :person_token)
      assert get_flash(conn, :info) =~ "Logged out successfully"
    end

    test "succeeds even if the person is not logged in", %{conn: conn} do
      conn = delete(conn, Routes.person_session_path(conn, :delete))
      assert redirected_to(conn) == "/"
      refute get_session(conn, :person_token)
      assert get_flash(conn, :info) =~ "Logged out successfully"
    end
  end
end
