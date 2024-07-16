defmodule Drafter.Golf.Tournament do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tournaments" do
    field(:name, :string)
    # has_many(:users, Drafter.Golf.User)
    # has_many(:players, Drafter.Golf.Player)

    timestamps()
  end

  @doc false
  def changeset(tournament, attrs) do
    tournament
    |> cast(attrs, [:name])
    |> validate_required(:name)
    |> unique_constraint(:name)
  end
end
