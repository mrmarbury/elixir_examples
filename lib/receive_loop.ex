defmodule Examples.ReceiveLoop do
  @moduledoc """
  Example for a Receive Loop
  """

  @doc """
  Hello world loop to demonstrate message passing between processes.

  pid1 = spawn(&Examples.ReceiveLoop.loop/0)
  pid2 = spawn(&Examples.ReceiveLoop.loop/0)

  send(pid1, {:hello, pid2})

  """

  def loop(monitored_pids \\ MapSet.new()) do
    Process.sleep(2_000)
    me = self()

    receive do
      {:hello, sender} ->
        IO.puts("#{inspect(me)}: Hello from #{inspect(sender)}")
        new_monitored_pids = maybe_monitor(sender, monitored_pids)

        if Process.alive?(sender) do
          send(sender, {:world, me})
        end

        loop(new_monitored_pids)

      {:world, sender} ->
        IO.puts("#{inspect(me)}: World from #{inspect(sender)}")
        new_monitored_pids = maybe_monitor(sender, monitored_pids)

        if Process.alive?(sender) do
          send(sender, {:hello, me})
        end

        loop(new_monitored_pids)

      :stop ->
        IO.puts("Stopping #{inspect(me)}")

      {:DOWN, _, :process, pid, reason} ->
        IO.puts(
          "Process #{inspect(pid)} died with reason #{inspect(reason)} ... Stopping as well"
        )

      any ->
        IO.puts("#{inspect(me)}: Ignoring unknown message #{inspect(any)}")
        loop()
    end
  end

  defp maybe_monitor(pid, monitored_pids) do
    if MapSet.member?(monitored_pids, pid) do
      monitored_pids
    else
      Process.monitor(pid)
      MapSet.put(monitored_pids, pid)
    end
  end
end
