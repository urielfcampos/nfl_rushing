defmodule NflRushing.Repo.Rushing do
  import Ecto.Query, only: [from: 2]
  alias NflRushing.Statistics.Rushing

  def list do
    from(s in Rushing, select: s)
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
end
