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

    {:ok, assign(socket, tournament: tournament, form: form)}
  end

  @impl true
  def handle_event("create_user", params, socket) do
    IO.inspect(params)
    IO.inspect(socket)
    Golf.create_user(params["user"])
    {:noreply, socket}
  end
end
