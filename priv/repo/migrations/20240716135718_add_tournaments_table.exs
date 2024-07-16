defmodule Drafter.Repo.Migrations.AddTournamentsTable do
  use Ecto.Migration

  def change do
    create table("tournaments") do
      add :name, :string
      
      timestamps()
    end

    create unique_index(:tournaments, [:name])
  end
end
