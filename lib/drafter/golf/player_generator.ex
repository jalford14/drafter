defmodule Drafter.Golf.PlayerGenerator do
  alias Drafter.Golf

  def generate(path, tournament_id) do
    path
    |> File.stream!(read_ahead: 100_000)
    |> CsvParser.parse_stream()
    |> Stream.map(fn [player, odds] ->
      %{name: :binary.copy(player), odds: :binary.copy(odds)}
    end)
    |> Enum.each(fn attrs ->
        Map.merge(attrs, %{tournament_id: tournament_id})
        |> Golf.create_player()
      end)
  end
end
