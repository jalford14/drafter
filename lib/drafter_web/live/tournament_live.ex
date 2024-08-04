defmodule DrafterWeb.TournamentLive do
  use DrafterWeb, :live_view

  alias Drafter.Golf
  alias Drafter.Golf.{User, Player}

  @impl true
  def mount(params, _session, socket) do
    DrafterWeb.Endpoint.subscribe("updates:topic:#{params["id"]}")

    tournament = Golf.get_tournament!(params["id"])
    undrafted_players = Golf.get_undrafted_players(tournament.id)
    form = %User{}
            |> Ecto.Changeset.change()
            |> to_form()

    player_form = %Player{}
            |> Ecto.Changeset.change()
            |> to_form()

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
  DrafterWeb.Endpoint.broadcast(
    "updates:topic:#{socket.assigns.tournament.id}",
    "user_created",
    socket.assigns.users ++ [user]
  )

  {:noreply, socket}
end

@impl true
def handle_event("start_draft", %{"player-id" => player_id}, socket) do
  player_id =
    case player_id == socket.assigns.selected_player_id do
      true -> nil
      false -> player_id
    end

  {:noreply, assign(socket, selected_player_id: player_id, draftable_users: socket.assigns.users)}
end

@impl true
def handle_event("draft_player", %{"user-id" => user_id}, socket) do
  player = socket.assigns.selected_player_id
  |> Golf.get_player!()

  Golf.Player.changeset(player, %{user_id: user_id})
  |> Golf.update_player!()

  leftover_players = socket.assigns.players -- [player]
  DrafterWeb.Endpoint.broadcast(
    "updates:topic:#{socket.assigns.tournament.id}",
    "player_drafted",
    leftover_players
  )

  {:noreply, assign(socket, selected_player_id: nil, draftable_users: nil)}
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
  def handle_event("delete_user", %{"user-id" => user_id}, socket) do
    user = Golf.get_user!(user_id)

    leftover_users =
      socket.assigns.users
      |> Enum.reject(fn curr_user -> curr_user.id == user.id end)

    Golf.delete_user!(user)
    socket = put_flash(socket, :info, "Deleted user!")

    DrafterWeb.Endpoint.broadcast(
      "updates:topic:#{socket.assigns.tournament.id}",
      "user_deleted",
      %{
        players: Golf.get_undrafted_players(socket.assigns.tournament.id),
        users: leftover_users
      }
    )
    {:noreply, socket}
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
      player.scores
      |> List.replace_at(String.to_integer(index), String.to_integer(score))

    Golf.Player.changeset(player, %{scores: updated_score})
    |> Golf.update_player!()

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "player_drafted", payload: available_players}, socket) do
    {:noreply, assign(socket, %{players: available_players})}
  end

  @impl true
  def handle_info(%{event: "user_created", payload: users}, socket) do
    {:noreply, assign(socket, users: users)}
  end

  @impl true
  def handle_info(%{event: "user_deleted", payload: payload}, socket) do
    {:noreply, assign(socket, players: payload[:players], users: payload[:users])}
  end
end
