defmodule WhatWhereWhen.People do
  @moduledoc """
  The People context.
  """

  import Ecto.Query, warn: false
  alias WhatWhereWhen.Repo
  alias WhatWhereWhen.People.{Person, PersonToken, PersonNotifier}

  ## Database getters

  @doc """
  Gets a person by email.

  ## Examples

      iex> get_person_by_email("foo@example.com")
      %Person{}

      iex> get_person_by_email("unknown@example.com")
      nil

  """
  def get_person_by_email(email) when is_binary(email) do
    Repo.get_by(Person, email: email)
  end

  @doc """
  Gets a single person.

  Raises `Ecto.NoResultsError` if the Person does not exist.

  ## Examples

      iex> get_person!(123)
      %Person{}

      iex> get_person!(456)
      ** (Ecto.NoResultsError)

  """
  def get_person!(id), do: Repo.get!(Person, id)

  def preregister_person(attrs) do
    %Person{}
    |> Person.preregistration_changeset(attrs)
    |> Repo.insert()
  end

  ## Person registration

  @doc """
  Registers a person.

  ## Examples

      iex> register_person(%{field: value})
      {:ok, %Person{}}

      iex> register_person(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_person(attrs) do
    %Person{}
    |> Person.changeset(attrs)
    |> Repo.insert()
  end

  ## Settings

  @doc """
  Returns an `%Ecto.Changeset{}` for changing person's details from incoming auth

  ## Examples

      iex> change_person(person)
      %Ecto.Changeset{data: %Person{}}

  """
  def change_person(person, attrs \\ %{}) do
    Person.changeset(person, attrs)
    |> Repo.update()
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_person_session_token(person) do
    {token, person_token} = PersonToken.build_session_token(person)
    Repo.insert!(person_token)
    token
  end

  @doc """
  Gets the person with the given signed token.
  """
  def get_person_by_session_token(token) do
    {:ok, query} = PersonToken.verify_session_token_query(token)

    Repo.one(query)
    |> Repo.preload(:camp)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_session_token(token) do
    Repo.delete_all(PersonToken.token_and_context_query(token, "session"))
    :ok
  end
end
