defmodule DrafterWeb.Router do
  use DrafterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DrafterWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DrafterWeb do
    pipe_through :browser

    live("/", HomeLive)
    live("/tournaments/:tournament_id", TournamentLive)
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:drafter, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DrafterWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
