defmodule Drafter.Golf.PlayerGenerator do
  use ExUnit.Case
  alias Drafter.Golf.PlayerGenerator
  @path "players.csv"

  test "creates players using a CSV" do
    assert(PlayerGenerator.generate(path) == :ok)
  end 
end
