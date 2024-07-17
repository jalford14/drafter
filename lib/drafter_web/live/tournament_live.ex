defmodule DrafterWeb.TournamentLive do
  use DrafterWeb, :live_view

  alias Drafter.Golf

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    name = Golf.get_tournament!(id).name
    {:ok, assign(socket, name: name)}
  end
end
