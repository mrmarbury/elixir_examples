defmodule Examples.JsonDecode do
  @moduledoc """
  for _ <- 1..10_000, do: spawn(&Examples.JsonDecode.decode/0)
  """
  require Jason

  def decode do
    {:ok, random_json} = File.read("assets/random_data.json")
    {_, data} = Jason.decode(random_json)
    data |> Map.keys() |> IO.inspect()
  end
end
