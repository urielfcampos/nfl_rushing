defmodule NflRushing.Util do
  def normalize_statistics(json) do
    Enum.map(json, fn map ->
      Map.put(map, "Yds", convert_to_float(map["Yds"]))
      |> Map.put("Lng", convert_to_string(map["Lng"]))
    end)
  end

  defp convert_to_float(value) when is_binary(value) do
    {value, _} =
      value
      |> String.replace(",", "")
      |> Integer.parse()

    value
  end

  defp convert_to_float(value), do: value

  defp convert_to_string(value) when is_integer(value) do
    Integer.to_string(value)
  end

  defp convert_to_string(value), do: value
end
