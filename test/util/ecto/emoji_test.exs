defmodule Util.Ecto.EmojiTest do
  use ExUnit.Case
  alias Util.Ecto.Emoji

  test "creates expected database versions" do
    assert "🍲" |> Emoji.cast() |> elem(1) |> Emoji.dump() == {:ok, ":stew:"}
    assert "🍹" |> Emoji.cast() |> elem(1) |> Emoji.dump() == {:ok, ":tropical_drink:"}
    assert "🎭" |> Emoji.cast() |> elem(1) |> Emoji.dump() == {:ok, ":performing_arts:"}
    assert "🎲" |> Emoji.cast() |> elem(1) |> Emoji.dump() == {:ok, ":game_die:"}
    assert "🏸" |> Emoji.cast() |> elem(1) |> Emoji.dump() == {:ok, ":badminton:"}
    assert "😘" |> Emoji.cast() |> elem(1) |> Emoji.dump() == {:ok, ":flirty:"}
    assert "🤯" |> Emoji.cast() |> elem(1) |> Emoji.dump() == {:ok, ":shocked:"}
    # of some note this one is a ZWJ sequence of person+school and thus 3 codepoints long
    assert "🧑‍🏫" |> Emoji.cast() |> elem(1) |> Emoji.dump() == {:ok, ":teacher:"}
    assert "🫖" |> Emoji.cast() |> elem(1) |> Emoji.dump() == {:ok, ":teapot:"}
  end

  test "can load also" do
    assert "👩‍🚀" == Emoji.load(":woman_astronaut:") |> elem(1) |> Map.get(:unicode)
    assert "🎴" == Emoji.load(":flower_cards:") |> elem(1) |> Map.get(:unicode)
    assert "🌞" == Emoji.load(":sun_face:") |> elem(1) |> Map.get(:unicode)
    assert "🪁" == Emoji.load(":kite:") |> elem(1) |> Map.get(:unicode)
    assert "🐦️" == Emoji.load(":bird:") |> elem(1) |> Map.get(:unicode)
  end

  # in the middle there is a in-memory format that is currently Emojix.Emoji info struct

  test "produces :error on bad inputs" do
    assert :error == Emoji.cast("a")
    assert :error == Emoji.load("nonesene")
    assert :error == Emoji.dump("othernonesense")
    assert :error == Emoji.load(":fake_emoji:")
    assert :error == Emoji.cast(":fake_emoji:")
  end
end
