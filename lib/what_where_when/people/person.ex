defmodule WhatWhereWhen.People.Person do
  use Ecto.Schema
  import Ecto.Schema
  import Ecto.Changeset

  alias WhatWhereWhen.ThemeCamps.Camp

  schema "people" do
    field :id_name, :string
    field :burn_name, :string

    field :email, :string

    belongs_to :camp, Camp

    timestamps()
  end

  def name(%{burn_name: bn}) when not is_nil(bn), do: bn
  def name(%{id_name: idn}), do: String.split(idn, " ") |> List.first()

  @doc false
  def changeset(person, attrs) do
    cs =
      person
      |> cast(attrs, [:id_name, :email, :burn_name])
      |> validate_required([:id_name, :email])
      |> unique_constraint(:email)

    with camp_name <- attrs[:where_camped] || attrs["where_camped"],
         false <- is_nil(camp_name),
         # if person already has a camp assigned in here, assume ticketing knows less
         nil <- get_field(cs, :camp_id),
         %Camp{} = camp_matching_name <- WhatWhereWhen.ThemeCamps.get_camp_from_name(camp_name) do
      put_change(cs, :camp_id, camp_matching_name.id)
    else
      _ ->
        cs
    end
  end

  @doc false
  def preregistration_changeset(person, attrs) do
    person
    |> cast(attrs, [:email, :id_name])
  end
end
