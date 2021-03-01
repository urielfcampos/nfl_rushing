defmodule NflRushing.Repo.RushingTest do
  use NflRushing.DataCase

  test "aggregated stats" do
    %NflRushing.Statistics.Rushing{
      Player: "Joe Banyard",
      Team: "JAX",
      Pos: "RB",
      Att: 2,
      "Att/G": 2.0,
      Yds: 7,
      Avg: 3.5,
      "Yds/G": 7.0,
      TD: 0,
      Lng: "7",
      "1st": 0,
      "1st%": 0.0,
      "20+": 0,
      "40+": 0,
      FUM: 0
    }
    |> NflRushing.Repo.insert()

    %NflRushing.Statistics.Rushing{
      Player: "Jonas Banyard",
      Team: "BUF",
      Pos: "RB",
      Att: 2,
      "Att/G": 2.0,
      Yds: 15,
      Avg: 3.5,
      "Yds/G": 7.0,
      TD: 0,
      Lng: "7",
      "1st": 0,
      "1st%": 0.0,
      "20+": 0,
      "40+": 0,
      FUM: 0
    }
    |> NflRushing.Repo.insert()

    %NflRushing.Statistics.Rushing{
      Player: "Reggie Bush",
      Team: "BUF",
      Pos: "RB",
      Att: 2,
      "Att/G": 2.0,
      Yds: 14,
      Avg: 3.5,
      "Yds/G": 7.0,
      TD: 0,
      Lng: "9",
      "1st": 0,
      "1st%": 0.0,
      "20+": 0,
      "40+": 0,
      FUM: 0
    }
    |> NflRushing.Repo.insert()

    grouped_stats = NflRushing.Repo.Rushing.list_group_by() |> NflRushing.Repo.all()

    first_team = Enum.at(grouped_stats, 0)
    second_team = Enum.at(grouped_stats, 1)

    assert first_team."Yds" == 29
    assert first_team."Lng" == 9
    assert second_team."Yds" == 7
  end
end
