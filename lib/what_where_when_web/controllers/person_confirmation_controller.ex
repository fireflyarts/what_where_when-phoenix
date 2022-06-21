defmodule WhatWhereWhenWeb.PersonConfirmationController do
  use WhatWhereWhenWeb, :controller

  alias WhatWhereWhen.People

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"person" => %{"email" => email}}) do
    if person = People.get_person_by_email(email) do
      People.deliver_person_confirmation_instructions(
        person,
        &Routes.person_confirmation_url(conn, :edit, &1)
      )
    end

    conn
    |> put_flash(
      :info,
      "If your email is in our system and it has not been confirmed yet, " <>
        "you will receive an email with instructions shortly."
    )
    |> redirect(to: "/")
  end

  def edit(conn, %{"token" => token}) do
    render(conn, "edit.html", token: token)
  end

  # Do not log in the person after confirmation to avoid a
  # leaked token giving the person access to the account.
  def update(conn, %{"token" => token}) do
    case People.confirm_person(token) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Person confirmed successfully.")
        |> redirect(to: "/")

      :error ->
        # If there is a current person and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the person themselves, so we redirect without
        # a warning message.
        case conn.assigns do
          %{current_person: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            redirect(conn, to: "/")

          %{} ->
            conn
            |> put_flash(:error, "Person confirmation link is invalid or it has expired.")
            |> redirect(to: "/")
        end
    end
  end
end
