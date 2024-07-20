defmodule DrafterWeb.TournamentLive do
  use DrafterWeb, :live_view

  alias Drafter.Golf
  alias Drafter.Golf.User

  @impl true
  def mount(params, _session, socket) do
    tournament = Golf.get_tournament!(params["id"])
    users = tournament.users
    form = %User{}
            |> Ecto.Changeset.change()
            |> to_form()

    {:ok, assign(socket, users: users, name: tournament.name, form: form)}
  end

  @impl true
  def handle_event("create_user", params, socket) do
    Golf.create_user(params)
    {:noreply, socket}
  end
end
