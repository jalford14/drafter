defmodule Drafter.Golf.PlayerGeneratorTest do
  use ExUnit.Case
  alias Drafter.Golf.PlayerGenerator

  test "creates players using a CSV" do
    assert(PlayerGenerator.generate() == :ok)
  end 
end
