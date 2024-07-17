defmodule DrafterWeb.HomeLive do
  use DrafterWeb, :live_view

  alias Drafter.Golf

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("new_draft", _params, socket) do
    name = "Jimmy's tourney"
    case Golf.create_tournament(%{name: name}) do
      {:ok, tournament} ->
        IO.puts "made thing"
        socket = put_flash(socket, :info, "New draft for #{name} started!")
        {:noreply, redirect(socket, to: "/tournaments/#{tournament.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        case changeset.errors do
          [name: {"has already been taken", _}] ->
            tournament = Golf.get_tournament_by_name(name)
            socket = 
              socket
              |> put_flash(:info, "Tournament already created.")
            
            {:noreply, redirect(socket, to: "/tournaments/#{tournament.id}")}

          _ ->
            socket = put_flash(socket, :error, "Something went wrong")
            {:noreply, assign(socket, :changeset, changeset)}
        end
    end
  end
end
