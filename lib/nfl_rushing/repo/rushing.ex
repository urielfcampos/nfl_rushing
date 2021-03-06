defmodule NflRushing.Repo.Rushing do
  import Ecto.Query, only: [from: 2]
  alias NflRushing.Statistics.Rushing

  def list do
    from(s in Rushing,
      select: %{
        "1st": s."1st",
        "1st%": s."1st%",
        "20+": s."20+",
        "40+": s."40+",
        Att: s."Att",
        "Att/G": s."Att/G",
        FUM: s."FUM",
        Lng: s."Lng",
        Player: s."Player",
        Pos: s."Pos",
        TD: s."TD",
        Team: s."Team",
        Yds: s."Yds",
        "Yds/G": s."Yds/G",
        Avg: s."Avg"
      }
    )
  end

  def filter_by_name(query, ""), do: query

  def filter_by_name(query, filter) do
    from(s in query, where: ilike(s."Player", ^"%#{filter}%"))
  end

  def sort_by(query, field, :desc) do
    from(s in query, order_by: [desc: field(s, ^field)])
  end

  def sort_by(query, field, :asc) do
    from(s in query, order_by: [asc: field(s, ^field)])
  end

  def insert_entries_from_file(file) do
    {:ok, rushing_stats} = NflRushing.JsonLoader.load_json(file)

    Enum.each(rushing_stats, fn rushing_stat ->
      NflRushing.Statistics.Rushing.changeset(%NflRushing.Statistics.Rushing{}, rushing_stat)
      |> NflRushing.Repo.insert!()
    end)
  end

  def list_group_by do
    from(s in Rushing,
      group_by: s."Team",
      order_by: [desc: sum(s."Yds")],
      select: %{
        Team: s."Team",
        Yds: sum(s."Yds"),
        Lng: fragment("max(replace(?, 'T', '')::integer)", s."Lng")
      }
    )
  end
end
