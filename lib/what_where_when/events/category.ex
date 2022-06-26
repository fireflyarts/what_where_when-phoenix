defmodule WhatWhereWhen.Events.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Util.Ecto.Emoji

  @derive {Jason.Encoder, only: ~w[name minimum_age emoji]a}

  schema "event_categories" do
    field :name
    field :emoji, Emoji

    field :minimum_age, :integer
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :emoji, :minimum_age])
    |> validate_required([:name, :emoji])
  end
end

defimpl String.Chars, for: WhatWhereWhen.Events.Category do
  def to_string(%WhatWhereWhen.Events.Category{minimum_age: 0, name: name}), do: name

  def to_string(%WhatWhereWhen.Events.Category{minimum_age: ma, name: name}),
    do: "#{name} [#{ma}+]"
end
