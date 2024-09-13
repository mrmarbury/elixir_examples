defmodule Examples do
  @moduledoc """
  Documentation for `Examples`.
  """
  require Logger

  @doc """
  Hello world.

  ## Examples

      iex> Examples.hello()
      :world

  """
  def start(_, _) do
    Examples.MySupervisor.start_link()
  end

  def hello do
    :world
  end
end
