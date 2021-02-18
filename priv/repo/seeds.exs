# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     NflRushing.Repo.insert!(%NflRushing.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{:ok, rushing_stats} = NflRushing.JsonLoader.load_json("rushing.json")

Enum.each(rushing_stats, fn rushing_stat ->
  NflRushing.Statistics.Rushing.changeset(%NflRushing.Statistics.Rushing{}, rushing_stat)
  |> NflRushing.Repo.insert!()
end)
