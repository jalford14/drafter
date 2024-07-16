defmodule Drafter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DrafterWeb.Telemetry,
      Drafter.Repo,
      {DNSCluster, query: Application.get_env(:drafter, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Drafter.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Drafter.Finch},
      # Start a worker by calling: Drafter.Worker.start_link(arg)
      # {Drafter.Worker, arg},
      # Start to serve requests, typically the last entry
      DrafterWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Drafter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DrafterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
