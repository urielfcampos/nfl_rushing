defmodule NflRushing.JsonLoader do
  alias NflRushing.Util

  def load_json(filename) do
    with {:ok, body} <- File.read(filename),
         {:ok, json} <- Jason.decode(body) do
      {:ok, Util.normalize_statistics(json)}
    else
      {:error, error} -> {:error, error}
    end
  end
end
