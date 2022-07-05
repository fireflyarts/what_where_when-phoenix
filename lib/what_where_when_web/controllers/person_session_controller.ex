defmodule WhatWhereWhenWeb.PersonSessionController do
  use WhatWhereWhenWeb, :controller

  alias WhatWhereWhen.People
  alias WhatWhereWhen.People.Person
  alias WhatWhereWhenWeb.PersonAuth

  def new(conn, _params) do
    if Mix.env() == :dev do
      render(conn, "new.html", error_message: nil)
    else
      redirect(conn, external: Util.TicketingAuth.outbound())
    end
  end

  def create(conn, params) do
    with :prod <- Mix.env(),
         auth <- Util.TicketingAuth.inbound_params(params),
         true <- auth[:signature_valid] && abs(auth[:delta_seconds]) < 60 do
      payload = auth[:payload]

      case People.get_person_by_email(payload.email) do
        nil ->
          {:ok, person} = People.register_person(Map.from_struct(payload))
          person

        %Person{} = person ->
          {:ok, person} = People.change_person(person, Map.from_struct(payload))
          person
      end
      |> then(&PersonAuth.log_in_person(conn, &1))
    else
      mix_env when mix_env == :dev or mix_env == :test ->
        case People.get_person_by_email(params["person"]["email"]) do
          nil ->
            IO.puts("User not found in dev/test log in, so forcing registration")
            {tag, person_or_cs} = People.register_person(params["person"])
            IO.inspect({tag, person_or_cs})

            person_or_cs

          person ->
            person
        end
        |> then(&PersonAuth.log_in_person(conn, &1))

      other_for_example_auth_failure ->
        IO.puts("Auth failure: ")
        IO.inspect(other_for_example_auth_failure)
        redirect(conn, to: "/", error_message: "Invalid auth")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> PersonAuth.log_out_person()
  end
end
