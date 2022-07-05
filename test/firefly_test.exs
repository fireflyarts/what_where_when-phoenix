defmodule FireflyTest do
  use ExUnit.Case, async: true

  describe "start_date/0, end_date/0, and date_range/0" do
    test "return expected types" do
      assert is_struct(Firefly.start_date(), Date)
      assert is_struct(Firefly.end_date(), Date)
      assert is_struct(Firefly.date_range(), Date.Range)
    end

    test "match" do
      assert Firefly.date_range().first == Firefly.start_date()
      assert Firefly.date_range().last == Firefly.end_date()
    end
  end
end
