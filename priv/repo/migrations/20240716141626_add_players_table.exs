defmodule Drafter.Repo.Migrations.AddPlayersTable do
  use Ecto.Migration

  def change do
    create table("players") do
      add :name, :string, null: false
      add :score, {:array, :integer}, default: []
      add :tournament_id, references(:tournaments), null: false
      add :user_id, references(:users)
      
      timestamps()
    end
  end
end
