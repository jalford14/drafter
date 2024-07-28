defmodule Drafter.Golf.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field(:name, :string)
    field(:scores, {:array, :integer}, default: [0, 0, 0, 0])
    field(:odds, :string)
    belongs_to(:tournament, Drafter.Golf.Tournament)
    belongs_to(:user, Drafter.Golf.User)

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :scores, :odds, :tournament_id, :user_id])
    |> validate_required([:name, :tournament_id])
  end
end
