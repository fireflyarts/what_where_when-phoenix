defmodule WhatWhereWhen.ThemeCamps do
  @moduledoc """
  The ThemeCamps context.
  """

  import Ecto.Query, warn: false
  alias WhatWhereWhen.Repo

  alias WhatWhereWhen.ThemeCamps.Camp

  @doc """
  Returns the list of camps.

  ## Examples

      iex> list_camps()
      [%Camp{}, ...]

  """
  def list_camps do
    Repo.all(Camp)
  end

  @doc """
  Gets a single camp.

  Raises `Ecto.NoResultsError` if the Camp does not exist.

  ## Examples

      iex> get_camp!(123)
      %Camp{}

      iex> get_camp!(456)
      ** (Ecto.NoResultsError)

  """
  def get_camp!(id), do: Repo.get!(Camp, id)

  @doc """
  Creates a camp.

  ## Examples

      iex> create_camp(%{field: value})
      {:ok, %Camp{}}

      iex> create_camp(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_camp(attrs \\ %{}) do
    primary_contact = WhatWhereWhen.People.get_person_by_email(attrs[:contact_email])

    real_attrs = %{name: attrs[:name], primary_contact_id: primary_contact.id}

    %Camp{}
    |> Camp.changeset(real_attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a camp.

  ## Examples

      iex> update_camp(camp, %{field: new_value})
      {:ok, %Camp{}}

      iex> update_camp(camp, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_camp(%Camp{} = camp, attrs) do
    camp
    |> Camp.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a camp.

  ## Examples

      iex> delete_camp(camp)
      {:ok, %Camp{}}

      iex> delete_camp(camp)
      {:error, %Ecto.Changeset{}}

  """
  def delete_camp(%Camp{} = camp) do
    Repo.delete(camp)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking camp changes.

  ## Examples

      iex> change_camp(camp)
      %Ecto.Changeset{data: %Camp{}}

  """
  def change_camp(%Camp{} = camp, attrs \\ %{}) do
    Camp.changeset(camp, attrs)
  end
end
