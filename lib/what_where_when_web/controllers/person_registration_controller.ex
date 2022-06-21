defmodule WhatWhereWhenWeb.PersonRegistrationController do
  use WhatWhereWhenWeb, :controller

  alias WhatWhereWhen.People
  alias WhatWhereWhen.People.Person
  alias WhatWhereWhenWeb.PersonAuth

  def new(conn, _params) do
    changeset = People.change_person_registration(%Person{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"person" => person_params}) do
    case People.register_person(person_params) do
      {:ok, person} ->
        {:ok, _} =
          People.deliver_person_confirmation_instructions(
            person,
            &Routes.person_confirmation_url(conn, :edit, &1)
          )

        conn
        |> put_flash(:info, "Person created successfully.")
        |> PersonAuth.log_in_person(person)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
