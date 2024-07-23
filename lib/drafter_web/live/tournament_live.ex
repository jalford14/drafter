defmodule DrafterWeb.TournamentLive do
  use DrafterWeb, :live_view

  alias Drafter.Golf
  alias Drafter.Golf.User

  @impl true
  def mount(params, _session, socket) do
    tournament = Golf.get_tournament!(params["id"])
    form = %User{}
            |> Ecto.Changeset.change()
            |> to_form()

    {:ok, assign(
            socket,
            tournament: tournament,
            users: tournament.users,
            form: form,
            selected_player: nil
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
    {:noreply, assign(socket, selected_player: player_id, draftable_users: socket.assigns.users)}
  end

  @impl true
  def handle_event("draft_player", %{"user-id" => user_id}, socket) do
    player = socket.assigns.selected_player
    |> Golf.get_player!()

    _changeset = Golf.Player.changeset(player, %{user_id: user_id})
    |> Golf.update_player!()
    {:noreply, assign(socket, selected_player: nil, draftable_users: nil)}
  end
end
