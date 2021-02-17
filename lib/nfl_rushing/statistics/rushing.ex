defmodule NflRushing.Statistics.Rushing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "statistics_rushings" do
    field :"1st", :integer
    field :"1st%", :float
    field :"20+", :integer
    field :"40+", :integer
    field :Att, :integer
    field :"Att/G", :float
    field :FUM, :integer
    field :Lng, :string
    field :Player, :string
    field :Pos, :string
    field :TD, :integer
    field :Team, :string
    field :Yds, :integer
    field :"Yds/G", :float
    field :Avg, :float

    timestamps()
  end

  @doc false
  def changeset(rushing, attrs) do
    rushing
    |> cast(attrs, [
      :Player,
      :Team,
      :Pos,
      :"Att/G",
      :Att,
      :Yds,
      :"Yds/G",
      :TD,
      :Lng,
      :"1st",
      :"1st%",
      :"20+",
      :"40+",
      :FUM,
      :Avg
    ])
    |> validate_required([
      :Player,
      :Team,
      :Pos,
      :"Att/G",
      :Att,
      :Yds,
      :"Yds/G",
      :TD,
      :Lng,
      :"1st",
      :"1st%",
      :"20+",
      :"40+",
      :FUM
    ])
  end
end
