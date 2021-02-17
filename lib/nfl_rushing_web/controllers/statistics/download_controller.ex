defmodule NflRushingWeb.Statistics.DownloadController do
  use NflRushingWeb, :controller

  def index(
        conn,
        %{"filter" => filter, "sort_order" => sort_order, "sort_by" => field} = _params
      ) do
    field_atom = String.to_atom(field)
    order_atom = String.to_atom(sort_order)

    stats =
      NflRushing.Repo.Rushing.list()
      |> NflRushing.Repo.Rushing.sort_by(field_atom, order_atom)
      |> NflRushing.Repo.Rushing.filter_by_name(filter)
      |> NflRushing.Repo.all()

    csv_file = NflRushing.Util.ExportTable.create_csv(stats)

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=dataset.csv")
    |> send_resp(200, csv_file)
  end
end
