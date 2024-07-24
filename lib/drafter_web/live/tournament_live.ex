defmodule DrafterWeb.TournamentLive do
  use DrafterWeb, :live_view

  alias Drafter.Golf
  alias Drafter.Golf.{User, Player}

  @impl true
  def mount(params, _session, socket) do
    tournament = Golf.get_tournament!(params["id"])
    undrafted_players = Golf.get_undrafted_players(tournament.id)
    form = %User{}
            |> Ecto.Changeset.change()
            |> to_form()

    player_form = %Player{}
            |> Ecto.Changeset.change()
            |> to_form()
            |> IO.inspect(label: "FORM")

    {:ok, assign(
            socket,
            tournament: tournament,
            users: tournament.users,
            players: undrafted_players,
            form: form,
            player_form: player_form,
            selected_user_id: nil,
            selected_player_id: nil,
            players_for_user: nil
          )}
  end

  @impl true
  def handle_event("create_user", params, socket) do
    {:ok, user} = Golf.create_user(params["user"])
    {:noreply, assign(socket, users: socket.assigns.users ++ [user])}
  end

  @impl true
  def handle_event("start_draft", %{"player-id" => player_id}, socket) do
    IO.inspect(player_id)
    {:noreply, assign(socket, selected_player_id: player_id, draftable_users: socket.assigns.users)}
  end

  @impl true
  def handle_event("draft_player", %{"user-id" => user_id}, socket) do
    player = socket.assigns.selected_player_id
    |> Golf.get_player!()

    Golf.Player.changeset(player, %{user_id: user_id})
    |> Golf.update_player!()

    leftover_players = socket.assigns.players -- [player]

    {:noreply, assign(socket, players: leftover_players, selected_player_id: nil, draftable_users: nil)}
  end

  @impl true
  def handle_event("toggle_user_players", %{"user-id" => user_id}, socket) do
    user = Golf.get_user!(user_id)
    user_id =
      case user_id == socket.assigns.selected_user_id do
        true -> nil
        false -> user_id
      end

    {:noreply, assign(socket, selected_user_id: user_id, players_for_user: user.players)}
  end

  @impl true
  def handle_event("update_score", %{"new_score" => ""}, socket), do:
    {:noreply, socket}

  @impl true
  def handle_event(
    "update_score",
    %{"player_id" => player_id, "score_index" => index, "new_score" => score},
    socket
  ) do
    player = Golf.get_player!(player_id)
    updated_score = 
      player.score
      |> List.replace_at(String.to_integer(index), String.to_integer(score))

    Golf.Player.changeset(player, %{score: updated_score})
    |> Golf.update_player!()

    {:noreply, socket}
  end
end
