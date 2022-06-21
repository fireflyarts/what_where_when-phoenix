defmodule WhatWhereWhenWeb.PersonConfirmationControllerTest do
  use WhatWhereWhenWeb.ConnCase

  alias WhatWhereWhen.People
  alias WhatWhereWhen.Repo
  import WhatWhereWhen.PeopleFixtures

  setup do
    %{person: person_fixture()}
  end

  describe "GET /people/confirm" do
    test "renders the resend confirmation page", %{conn: conn} do
      conn = get(conn, Routes.person_confirmation_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Resend confirmation instructions</h1>"
    end
  end

  describe "POST /people/confirm" do
    @tag :capture_log
    test "sends a new confirmation token", %{conn: conn, person: person} do
      conn =
        post(conn, Routes.person_confirmation_path(conn, :create), %{
          "person" => %{"email" => person.email}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your email is in our system"
      assert Repo.get_by!(People.PersonToken, person_id: person.id).context == "confirm"
    end

    test "does not send confirmation token if Person is confirmed", %{conn: conn, person: person} do
      Repo.update!(People.Person.confirm_changeset(person))

      conn =
        post(conn, Routes.person_confirmation_path(conn, :create), %{
          "person" => %{"email" => person.email}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your email is in our system"
      refute Repo.get_by(People.PersonToken, person_id: person.id)
    end

    test "does not send confirmation token if email is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.person_confirmation_path(conn, :create), %{
          "person" => %{"email" => "unknown@example.com"}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your email is in our system"
      assert Repo.all(People.PersonToken) == []
    end
  end

  describe "GET /people/confirm/:token" do
    test "renders the confirmation page", %{conn: conn} do
      conn = get(conn, Routes.person_confirmation_path(conn, :edit, "some-token"))
      response = html_response(conn, 200)
      assert response =~ "<h1>Confirm account</h1>"

      form_action = Routes.person_confirmation_path(conn, :update, "some-token")
      assert response =~ "action=\"#{form_action}\""
    end
  end

  describe "POST /people/confirm/:token" do
    test "confirms the given token once", %{conn: conn, person: person} do
      token =
        extract_person_token(fn url ->
          People.deliver_person_confirmation_instructions(person, url)
        end)

      conn = post(conn, Routes.person_confirmation_path(conn, :update, token))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "Person confirmed successfully"
      assert People.get_person!(person.id).confirmed_at
      refute get_session(conn, :person_token)
      assert Repo.all(People.PersonToken) == []

      # When not logged in
      conn = post(conn, Routes.person_confirmation_path(conn, :update, token))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) =~ "Person confirmation link is invalid or it has expired"

      # When logged in
      conn =
        build_conn()
        |> log_in_person(person)
        |> post(Routes.person_confirmation_path(conn, :update, token))

      assert redirected_to(conn) == "/"
      refute get_flash(conn, :error)
    end

    test "does not confirm email with invalid token", %{conn: conn, person: person} do
      conn = post(conn, Routes.person_confirmation_path(conn, :update, "oops"))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) =~ "Person confirmation link is invalid or it has expired"
      refute People.get_person!(person.id).confirmed_at
    end
  end
end
