defmodule Drafter.Golf do
  @moduledoc """
  The Golf context for managing tournaments, users, and players.
  """

  import Ecto.Query, warn: false
  alias Drafter.Repo

  alias Drafter.Golf.Tournament
  alias Drafter.Golf.User
  alias Drafter.Golf.Player

  @doc """
  Gets a single tournament and preloads users.
  """
  def get_tournament!(id) do
    Repo.get!(Tournament, id)
    |> Repo.preload([:users, :players])
  end

  @doc """
  Gets a tournament by passing in a name.
  """
  def get_tournament_by_name(name), do: Repo.get_by(Tournament, name: name)

  @doc """
  Creates a tournament.
  """
  def create_tournament(attrs \\ %{}) do
    %Tournament{}
    |> Tournament.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a user.
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a player.
  """
  def create_player(attrs \\ %{}) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end
end
