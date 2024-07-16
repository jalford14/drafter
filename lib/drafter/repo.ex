defmodule Drafter.Repo do
  use Ecto.Repo,
    otp_app: :drafter,
    adapter: Ecto.Adapters.Postgres
end
