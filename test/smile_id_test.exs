defmodule SmileIdTest do
  use ExUnit.Case
  doctest SmileId

  test "new/0 returns a SmileId struct" do
    assert SmileId.new() |> is_struct(SmileId)
  end
end
