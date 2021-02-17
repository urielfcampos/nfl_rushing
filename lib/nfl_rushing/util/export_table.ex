defmodule NflRushing.Util.ExportTable do
  @csv_headers [
    "1st",
    "1st%",
    "20+",
    "40+",
    "Att",
    "Att/G",
    "FUM",
    "Lng",
    "Player",
    "Pos",
    "TD",
    "Team",
    "Yds",
    "Yds/G",
    "Avg"
  ]

  def create_csv(data) do
    parse_data(data)
    |> CSV.encode(headers: @csv_headers)
    |> Enum.to_list()
  end

  def parse_data(data) do
    Stream.map(data, fn map ->
      %{
        "1st" => map."1st",
        "1st%" => map."1st%",
        "20+" => map."20+",
        "40+" => map."40+",
        "Att" => map."Att",
        "Att/G" => map."Att/G",
        "FUM" => map."FUM",
        "Lng" => map."Lng",
        "Player" => map."Player",
        "Pos" => map."Pos",
        "TD" => map."TD",
        "Team" => map."Team",
        "Yds" => map."Yds",
        "Yds/G" => map."Yds/G",
        "Avg" => map."Avg"
      }
    end)
  end
end
