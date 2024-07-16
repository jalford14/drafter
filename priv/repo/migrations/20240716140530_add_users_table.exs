defmodule Drafter.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table("users") do
      add :name, :string, null: false
      add :color_hex, :string
      add :tournament_id, references(:tournaments), null: false
      
      timestamps()
    end
  end
end
