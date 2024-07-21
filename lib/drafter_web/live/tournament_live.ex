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
            form: form
          )}
  end

  @impl true
  def handle_event("create_user", params, socket) do
    user = Golf.create_user(params["user"])
    {:noreply, assign(socket, users: socket.assigns.tournament.users ++ [user])}
  end
end
