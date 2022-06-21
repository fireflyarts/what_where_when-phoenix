defmodule WhatWhereWhenWeb.PersonResetPasswordControllerTest do
  use WhatWhereWhenWeb.ConnCase

  alias WhatWhereWhen.People
  alias WhatWhereWhen.Repo
  import WhatWhereWhen.PeopleFixtures

  setup do
    %{person: person_fixture()}
  end

  describe "GET /people/reset_password" do
    test "renders the reset password page", %{conn: conn} do
      conn = get(conn, Routes.person_reset_password_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Forgot your password?</h1>"
    end
  end

  describe "POST /people/reset_password" do
    @tag :capture_log
    test "sends a new reset password token", %{conn: conn, person: person} do
      conn =
        post(conn, Routes.person_reset_password_path(conn, :create), %{
          "person" => %{"email" => person.email}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your email is in our system"
      assert Repo.get_by!(People.PersonToken, person_id: person.id).context == "reset_password"
    end

    test "does not send reset password token if email is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.person_reset_password_path(conn, :create), %{
          "person" => %{"email" => "unknown@example.com"}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your email is in our system"
      assert Repo.all(People.PersonToken) == []
    end
  end

  describe "GET /people/reset_password/:token" do
    setup %{person: person} do
      token =
        extract_person_token(fn url ->
          People.deliver_person_reset_password_instructions(person, url)
        end)

      %{token: token}
    end

    test "renders reset password", %{conn: conn, token: token} do
      conn = get(conn, Routes.person_reset_password_path(conn, :edit, token))
      assert html_response(conn, 200) =~ "<h1>Reset password</h1>"
    end

    test "does not render reset password with invalid token", %{conn: conn} do
      conn = get(conn, Routes.person_reset_password_path(conn, :edit, "oops"))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) =~ "Reset password link is invalid or it has expired"
    end
  end

  describe "PUT /people/reset_password/:token" do
    setup %{person: person} do
      token =
        extract_person_token(fn url ->
          People.deliver_person_reset_password_instructions(person, url)
        end)

      %{token: token}
    end

    test "resets password once", %{conn: conn, person: person, token: token} do
      conn =
        put(conn, Routes.person_reset_password_path(conn, :update, token), %{
          "person" => %{
            "password" => "new valid password",
            "password_confirmation" => "new valid password"
          }
        })

      assert redirected_to(conn) == Routes.person_session_path(conn, :new)
      refute get_session(conn, :person_token)
      assert get_flash(conn, :info) =~ "Password reset successfully"
      assert People.get_person_by_email_and_password(person.email, "new valid password")
    end

    test "does not reset password on invalid data", %{conn: conn, token: token} do
      conn =
        put(conn, Routes.person_reset_password_path(conn, :update, token), %{
          "person" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })

      response = html_response(conn, 200)
      assert response =~ "<h1>Reset password</h1>"
      assert response =~ "should be at least 12 characters"
      assert response =~ "does not match password"
    end

    test "does not reset password with invalid token", %{conn: conn} do
      conn = put(conn, Routes.person_reset_password_path(conn, :update, "oops"))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) =~ "Reset password link is invalid or it has expired"
    end
  end
end
