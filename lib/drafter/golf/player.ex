defmodule Drafter.Golf.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field(:name, :string)
    field(:score, {:array, :integer})
    field(:odds, :string)
    belongs_to(:tournament, Drafter.Golf.Tournament)
    belongs_to(:user, Drafter.Golf.User)

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :score, :odds, :tournament_id, :user_id])
    |> validate_required([:name, :tournament_id])
  end
end
