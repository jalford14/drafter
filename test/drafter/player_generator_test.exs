defmodule Drafter.Golf.PlayerGeneratorTest do
  use ExUnit.Case, async: true
  alias Drafter.Repo
  alias Drafter.Golf
  alias Drafter.Golf.{PlayerGenerator, Player}

  @path "players.csv"

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    {:ok, tournament} = Golf.create_tournament(%{name: "test"})
    %{tournament: tournament}
  end

  test "creates players using a CSV", %{tournament: tournament} do
    PlayerGenerator.generate(@path, tournament.id)
    player_count = Repo.aggregate(Player, :count)
    assert(player_count == 148)
  end 
end
