defmodule NflRushing.Repo.Migrations.CreateStatisticsRushings do
  use Ecto.Migration

  def change do
    create table(:statistics_rushings) do
      add :Player, :string
      add :Team, :string
      add :Pos, :string
      add :"Att/G", :float
      add :Att, :integer
      add :Yds, :integer
      add :"Yds/G", :float
      add :TD, :integer
      add :Lng, :string
      add :"1st", :integer
      add :"1st%", :float
      add :"20+", :integer
      add :"40+", :integer
      add :FUM, :integer
      add :Avg, :float

      timestamps()
    end
  end
end
