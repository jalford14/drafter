defmodule Drafter.Repo.Migrations.AddOddsToPlayers do
  use Ecto.Migration

  def change do
    alter table(:players) do
      add :odds, :string
    end
  end
end
