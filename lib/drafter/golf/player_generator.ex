defmodule Drafter.Golf.PlayerGenerator do
  @path "players.csv"

  def generate do
    @path
    |> File.stream!(read_ahead: 100_000)
    |> CsvParser.parse_stream()
    |> Stream.map(fn [player, odds] ->
      %{name: :binary.copy(player), odds: :binary.copy(odds)}
    end)
    |> Stream.run()
  end
end
