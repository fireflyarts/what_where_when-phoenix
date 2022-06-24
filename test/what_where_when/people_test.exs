defmodule WhatWhereWhen.PeopleTest do
  use WhatWhereWhen.DataCase

  alias WhatWhereWhen.People

  import WhatWhereWhen.PeopleFixtures
  alias WhatWhereWhen.People.{Person, PersonToken}

  describe "get_person_by_email/1" do
    test "does not return the person if the email does not exist" do
      refute People.get_person_by_email("unknown@example.com")
    end

    test "returns the person if the email exists" do
      %{id: id} = person = person_fixture()
      assert %Person{id: ^id} = People.get_person_by_email(person.email)
    end
  end

  describe "get_person!/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        People.get_person!(-1)
      end
    end

    test "returns the person with the given id" do
      %{id: id} = person = person_fixture()
      assert %Person{id: ^id} = People.get_person!(person.id)
    end
  end

  describe "register_person/1" do
    test "requires email, id_names to be set" do
      {:error, changeset} = People.register_person(%{})

      assert %{
               id_name: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "validates email uniqueness" do
      %{email: email} = p = person_fixture()
      {:error, changeset} = People.register_person(Map.from_struct(p))
      assert "has already been taken" in errors_on(changeset).email

      # Now try with the upper cased email too, to check that email case is ignored.
      {:error, changeset} =
        People.register_person(%{email: String.upcase(email), id_name: p.id_name})

      assert "has already been taken" in errors_on(changeset).email
    end
  end

  describe "change_person/2" do
    test "returns a changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = People.change_person(%Person{})
      assert changeset.required == [:id_name, :email]
    end

    test "allows fields to be set" do
      email = unique_person_email()

      changeset = People.Person.changeset(%Person{}, valid_person_attributes(email: email))

      assert changeset.valid?
      assert get_change(changeset, :email) == email
      assert get_change(changeset, :id_name) == "Alba Person"
    end
  end

  describe "generate_person_session_token/1" do
    setup do
      %{person: person_fixture()}
    end

    test "generates a token", %{person: person} do
      token = People.generate_person_session_token(person)
      assert person_token = Repo.get_by(PersonToken, token: token)
      assert person_token.context == "session"

      # Creating the same token for another person should fail
      assert_raise Ecto.ConstraintError, fn ->
        Repo.insert!(%PersonToken{
          token: person_token.token,
          person_id: person_fixture().id,
          context: "session"
        })
      end
    end
  end

  describe "get_person_by_session_token/1" do
    setup do
      person = person_fixture()
      token = People.generate_person_session_token(person)
      %{person: person, token: token}
    end

    test "returns person by token", %{person: person, token: token} do
      assert session_person = People.get_person_by_session_token(token)
      assert session_person.id == person.id
    end

    test "does not return person for invalid token" do
      refute People.get_person_by_session_token("oops")
    end

    test "does not return person for expired token", %{token: token} do
      {1, nil} = Repo.update_all(PersonToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute People.get_person_by_session_token(token)
    end
  end

  describe "delete_session_token/1" do
    test "deletes the token" do
      person = person_fixture()
      token = People.generate_person_session_token(person)
      assert People.delete_session_token(token) == :ok
      refute People.get_person_by_session_token(token)
    end
  end
end
