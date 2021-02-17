defmodule NflRushingWeb.Statistics.RushingLive do
  use NflRushingWeb, :live_view
  alias NflRushing.Statistics.Rushing
  @impl true
  def mount(_params, _session, socket) do
    rushing_stats = NflRushing.Repo.all(Rushing)
    {:ok, assign(socket, query: "", stats: rushing_stats)}
  end

  @impl true
  def handle_event("filter", %{"filter" => filter} = params, socket) do
    filtered_stats =
      NflRushing.Repo.Rushing.list()
      |> NflRushing.Repo.Rushing.filter_by_name(filter)
      |> NflRushing.Repo.all()

    IO.inspect(socket)
    {:noreply, assign(socket, query: filter, stats: filtered_stats)}
  end

  @impl true
  def handle_params(%{"sort_by" => field, "filter" => filter}, _, socket) do
    case field do
      field when field in ~w(TD Lng Yds) ->
        field_atom = String.to_atom(field)

        sorted_filtered_stats =
          NflRushing.Repo.Rushing.list()
          |> NflRushing.Repo.Rushing.sort_by(field_atom, :desc)
          |> NflRushing.Repo.Rushing.filter_by_name(filter)
          |> NflRushing.Repo.all()

        {:noreply, assign(socket, query: filter, stats: sorted_filtered_stats)}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_params(params, _uri, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end
end
