defmodule NflRushingWeb.Statistics.RushingLiveTest do
  use NflRushingWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "NFL Rushing Statistics"
    assert render(page_live) =~ "NFL Rushing Statistics"
  end

  test "filter data", %{conn: conn} do
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

    {:ok, view, _template} = live(conn, "/")

    assert view |> element("#filter_form") |> render_change(%{filter: "Jonas"}) =~ "Jonas Banyard"
    refute view |> element("#filter_form") |> render_change(%{filter: "Jonas"}) =~ "Joe"
  end

  test "upload file", %{conn: conn} do
    {:ok, view, _template} = live(conn, "/")

    data =
      file_input(view, "#upload_form", :data, [
        %{
          name: "rushing.json",
          content: File.read!("rushing.json"),
          type: "application/json"
        }
      ])

    assert render_upload(data, "rushing.json")
    assert view |> form("#upload_form") |> render_submit(data) =~ "Joe"
  end
end
