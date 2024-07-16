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
    socket = put_flash(socket, :info, "New draft!")
    case Golf.create_tournament(%{name: name}) do
      {:ok, tournament} ->
        socket = put_flash(socket, :info, "New draft for #{name} started!")
            {:noreply, redirect(socket, to: "/tournaments/#{tournament.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
