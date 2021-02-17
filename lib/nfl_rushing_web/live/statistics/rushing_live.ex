defmodule NflRushingWeb.Statistics.RushingLive do
  use NflRushingWeb, :live_view
  @impl true
  def mount(_params, _session, socket) do
    rushing_stats = NflRushing.Repo.Rushing.list() |> NflRushing.Repo.all()
    {:ok, assign(socket, query: "", stats: rushing_stats, sort_order: "desc", sort_by: "TD")}
  end

  @impl true
  def handle_event(
        "filter",
        %{"filter" => filter},
        %{assigns: %{sort_order: sort_order, sort_by: field}} = socket
      ) do
    filtered_stats = filter_stats(filter, field, sort_order)

    {:noreply, assign(socket, query: filter, stats: filtered_stats)}
  end

  @impl true
  def handle_params(
        %{"sort_by" => field, "filter" => filter, "sort_order" => sort_order},
        _,
        socket
      ) do
    case field do
      field when field in ~w(TD Lng Yds) ->
        sorted_filtered_stats = filter_stats(filter, field, sort_order)

        sort_order = get_sort_order(sort_order)

        {:noreply,
         assign(socket,
           query: filter,
           stats: sorted_filtered_stats,
           sort_order: sort_order,
           sort_by: field
         )}

      _ ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  defp filter_stats(filter, field, order) do
    field_atom = String.to_atom(field)
    order_atom = String.to_atom(order)

    NflRushing.Repo.Rushing.list()
    |> NflRushing.Repo.Rushing.sort_by(field_atom, order_atom)
    |> NflRushing.Repo.Rushing.filter_by_name(filter)
    |> NflRushing.Repo.all()
  end

  defp get_sort_order(sort_order) do
    case sort_order do
      "asc" -> "desc"
      "desc" -> "asc"
    end
  end
end
