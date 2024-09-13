defmodule Examples.MyGenServer do
  @moduledoc """
    Outside the process that we create here,
    there could be a storm raging. But inside, things are calm.
    Here we can focus on what that process should do - and only that.
  """
  use GenServer
  require Logger

  ###################################################################
  # API - where we define what the outside world can "ask" us to do #
  ###################################################################

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts[:name], opts)
  end

  def stop(pid) do
    GenServer.stop(pid)
  end

  def add_list_items(list, pid) do
    GenServer.call(pid, {:add, list})
  end

  def get_count(pid) do
    GenServer.call(pid, :get_count)
  end

  def get_info_calls(pid) do
    GenServer.call(pid, :get_info_calls)
  end

  def subtract_list_items(list, pid) do
    GenServer.cast(pid, {:subtract, list})
  end

  def reset_counter(pid) do
    GenServer.cast(pid, :reset_counter)
  end

  #############################################################################
  # Callbacks - our boundary between the outside world and our business logic #
  #           - we also manage our State here
  #############################################################################
  @impl true
  def init(name) do
    Logger.info("Starting #{name}")
    init_state = %{counter: 0, name: name, info_calls: []}
    {:ok, init_state}
  end

  @impl true
  def terminate(:normal, state) do
    Logger.info("Stopping #{state[:name]}")
  end

  @impl true
  def handle_call({:add, list}, _, state) do
    count = add(list, state[:counter])
    Logger.info("New Counter Value is #{count}")
    new_state = %{state | counter: count}
    {:reply, count, new_state, {:continue, :add_one}}
  end

  @impl true
  def handle_call(:get_count, _, state) do
    {:reply, state[:counter], state}
  end

  @impl true
  def handle_call(:get_info_calls, _, state) do
    {:reply, state[:info_calls], state}
  end

  @impl true
  def handle_cast({:subtract, list}, state) do
    count = subtract(list, state[:counter])
    Logger.info("New Counter Value is #{count}")
    new_state = %{state | counter: count}
    {:noreply, new_state}
  end

  @impl true
  def handle_cast(:reset_counter, state) do
    {:noreply, %{state | counter: 0}}
  end

  @impl true
  def handle_continue(:add_one, state) do
    new_state = %{state | counter: state[:counter] + 1}
    {:noreply, new_state}
  end

  @impl true
  def handle_info(:flush_info_calls, state) do
    new_state = %{state | info_calls: []}
    {:noreply, new_state}
  end

  @impl true
  def handle_info(message, state) do
    Logger.info("Handle Info called with message #{message}")
    collected_calls = [message | state[:info_calls]]
    new_state = %{state | info_calls: collected_calls}
    {:noreply, new_state}
  end

  ###########################################
  # Private Functions - The functional core #
  ###########################################

  defp add([], counter), do: counter

  defp add([item | list], counter) do
    case counter do
      0 -> add(list, item)
      _ -> add(list, counter + item)
    end
  end

  defp subtract(_, 0), do: 0

  defp subtract([], counter), do: counter

  defp subtract([item | list], counter) do
    case will_be_null?(counter, item) do
      true -> 0
      false -> subtract(list, counter - item)
    end
  end

  defp will_be_null?(counter, item) do
    counter - item <= 0
  end
end
