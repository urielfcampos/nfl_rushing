defmodule NflRushingWeb.Statistics.RushingLive do
  use NflRushingWeb, :live_view
  @impl true
  def mount(_params, _session, socket) do
    rushing_stats = NflRushing.Repo.Rushing.list() |> NflRushing.Repo.all()
    grouped_team_stats = NflRushing.Repo.Rushing.list_group_by() |> NflRushing.Repo.all()

    {:ok,
     assign(socket,
       query: "",
       stats: rushing_stats,
       grouped_stats: grouped_team_stats,
       sort_order: "desc",
       sort_by: "TD",
       uploaded_files: []
     )
     |> allow_upload(:data,
       accept: ~w(.json),
       max_entries: 1
     )}
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

  def handle_event(
        "load_data",
        _params,
        %{assigns: %{sort_order: sort_order, sort_by: field, query: filter}} = socket
      ) do
    inserted_entries =
      consume_uploaded_entries(socket, :data, fn %{path: path}, _entry ->
        NflRushing.Repo.Rushing.insert_entries_from_file(path)
      end)

    case inserted_entries do
      [:ok] ->
        updated_stats = filter_stats(filter, field, sort_order)

        {:noreply,
         socket
         |> assign(stats: updated_stats)
         |> put_flash(:info, NflRushingWeb.Gettext.gettext("Entries loaded"))}

      _ ->
        {:noreply,
         put_flash(socket, :error, NflRushingWeb.Gettext.gettext("Error Uploading file"))}
    end
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
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
