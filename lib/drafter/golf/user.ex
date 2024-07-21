defmodule Drafter.Golf.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:name, :string)
    field(:color_hex, :string)
    belongs_to(:tournament, Drafter.Golf.Tournament)
    has_many(:players, Drafter.Golf.Player)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :color_hex, :tournament_id])
    |> validate_required([:name, :tournament_id])
  end
end
