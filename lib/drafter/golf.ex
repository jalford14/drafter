defmodule Drafter.Golf do
  @moduledoc """
  The Golf context for managing tournaments, users, and players.
  """

  import Ecto.Query, warn: false
  alias Drafter.Repo

  alias Drafter.Golf.Tournament
  alias Drafter.Golf.User
  alias Drafter.Golf.Player

  @total_scores 4

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
  Take the players scores from each day and aggregate them together to get
  each days totals.
  """
  def aggreagate_user_scores(user_id) do
    query = from p in "players",
            where: p.user_id == ^user_id,
            select: p.score

    scores = Repo.all(query)
    |> Enum.zip()
    |> Enum.map(fn scores -> Tuple.sum(scores) end)

    # Add arrays in for nil scores. This is to make sure
    # that table cells are all present for the html
    case @total_scores - Enum.count(scores) do
      0 -> scores
      blanks -> scores ++ List.duplicate([], blanks)
    end
  end

  @doc """
<<<<<<< Updated upstream
=======
  Gets a single player and preloads users.
  """
  def get_player!(id) do
    Repo.get!(Player, id)
  end

  @doc """
>>>>>>> Stashed changes
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
  def update_player!(attrs \\ %{}) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.update!()
  end
end
