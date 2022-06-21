defmodule WhatWhereWhenWeb.PersonSessionControllerTest do
  use WhatWhereWhenWeb.ConnCase

  import WhatWhereWhen.PeopleFixtures

  setup do
    %{person: person_fixture()}
  end

  describe "GET /people/log_in" do
    test "renders log in page", %{conn: conn} do
      conn = get(conn, Routes.person_session_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Log in</h1>"
      assert response =~ "Register</a>"
      assert response =~ "Forgot your password?</a>"
    end

    test "redirects if already logged in", %{conn: conn, person: person} do
      conn = conn |> log_in_person(person) |> get(Routes.person_session_path(conn, :new))
      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /people/log_in" do
    test "logs the person in", %{conn: conn, person: person} do
      conn =
        post(conn, Routes.person_session_path(conn, :create), %{
          "person" => %{"email" => person.email, "password" => valid_person_password()}
        })

      assert get_session(conn, :person_token)
      assert redirected_to(conn) == "/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ person.email
      assert response =~ "Settings</a>"
      assert response =~ "Log out</a>"
    end

    test "logs the person in with remember me", %{conn: conn, person: person} do
      conn =
        post(conn, Routes.person_session_path(conn, :create), %{
          "person" => %{
            "email" => person.email,
            "password" => valid_person_password(),
            "remember_me" => "true"
          }
        })

      assert conn.resp_cookies["_what_where_when_web_person_remember_me"]
      assert redirected_to(conn) == "/"
    end

    test "logs the person in with return to", %{conn: conn, person: person} do
      conn =
        conn
        |> init_test_session(person_return_to: "/foo/bar")
        |> post(Routes.person_session_path(conn, :create), %{
          "person" => %{
            "email" => person.email,
            "password" => valid_person_password()
          }
        })

      assert redirected_to(conn) == "/foo/bar"
    end

    test "emits error message with invalid credentials", %{conn: conn, person: person} do
      conn =
        post(conn, Routes.person_session_path(conn, :create), %{
          "person" => %{"email" => person.email, "password" => "invalid_password"}
        })

      response = html_response(conn, 200)
      assert response =~ "<h1>Log in</h1>"
      assert response =~ "Invalid email or password"
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
