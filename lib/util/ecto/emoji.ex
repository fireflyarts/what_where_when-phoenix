defmodule Util.Ecto.Emoji do
  use Ecto.Type

  @moduledoc """
  Adapts a lone emoji (e.g. for an icon) as a database & CLI / a11y friendly datatype

  DB native fomat is colon(`:`)-infixed short name, so e.g.
  > 🎭 => ":performing_arts:"
  > 😅 => ":sweat_smile:"

  The in-memory format is %Emojix.Emoji{}. Actual graphemes are treated as a tx enconding
  """

  @type colon_infixed_binary() :: binary()
  defguardp is_colon_infixed_binary(s)
            when is_binary(s) and binary_part(s, 0, 1) == ":" and
                   binary_part(s, byte_size(s) - 1, 1) == ":"

  @type t() :: Emojix.Emoji.t()

  @spec type() :: colon_infixed_binary()
  def type, do: :string

  @spec cast(colon_infixed_binary() | String.grapheme()) :: {:ok, t()} | :error

  def cast(s) when is_colon_infixed_binary(s), do: s |> drop_colons |> tagged_from_short_name

  def cast(grapheme) when is_binary(grapheme) do
    case Emojix.find_by_unicode(grapheme) do
      nil -> :error
      e -> {:ok, e}
    end
  end

  @spec dump(t()) :: {:ok, colon_infixed_binary()} | :error
  def dump(%Emojix.Emoji{} = e), do: {:ok, colon_infixed(shortest_short_code(e))}
  def dump(_), do: :error

  def load(data) when is_colon_infixed_binary(data),
    do: data |> drop_colons |> tagged_from_short_name

  def load(_), do: :error

  @spec colon_infixed(binary()) :: colon_infixed_binary()

  defp colon_infixed(s) when is_colon_infixed_binary(s), do: s
  defp colon_infixed(s) when is_binary(s), do: ":" <> s <> ":"

  defp drop_colons(s) when is_colon_infixed_binary(s), do: binary_part(s, 1, byte_size(s) - 2)

  defp tagged_from_short_name(short_name) do
    case Emojix.find_by_shortcode(short_name) do
      nil -> :error
      char -> {:ok, char}
    end
  end

  defp shortest_short_code(%Emojix.Emoji{} = e) do
    e.shortcodes
    |> Enum.sort_by(&String.length/1)
    |> List.first()
  end
end
