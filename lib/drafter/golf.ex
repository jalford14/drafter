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
  Gets a single tournament and preloads players.
  """
  def get_user!(id) do
    Repo.get!(User, id)
    |> Repo.preload(:players)
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
  Returns a map of the players scores and their total. The scores are
  from each day and aggregated together into a list. The total is a sum
  of all values in the list.
  """
  def aggregate_user_scores(user_id) do
    query = from p in "players",
            where: p.user_id == ^user_id,
            select: p.scores

    case Repo.all(query) do
      [] -> 
        [0,0,0,0]
      result ->
        result
        |> Enum.zip()
        |> Enum.map(fn scores -> Tuple.sum(scores) end)
    end
  end

  @doc """
  Gets a single player and preloads users.
  """
  def get_player!(id) do
    Repo.get(Player, id)
  end

  @doc """
  Creates a player.
  """
  def create_player(attrs \\ %{}) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a player.
  """
  def update_player!(changeset), do: Repo.update!(changeset)

  @doc """
  Get all undrafted players.
  """
  def get_undrafted_players(tournament_id) do
    query = from p in Player,
            where: is_nil(p.user_id)
                   and p.tournament_id == ^tournament_id

    Repo.all(query)
  end
end
