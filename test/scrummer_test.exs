defmodule ScrummerTest do
  use ExUnit.Case
  doctest Scrummer

  test "greets the world" do
    assert Scrummer.hello() == :world
  end
end
