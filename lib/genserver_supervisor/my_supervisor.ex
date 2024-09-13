defmodule Examples.MySupervisor do
  @moduledoc false
  use Supervisor
  require Logger

  alias Examples.MyGenServer

  #################
  # The API again #
  #################

  def start_link(args \\ []) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  #####################################
  # Callback - there is just one here #
  #####################################

  @impl true
  def init(_args) do
    Logger.info("Starting Supervisor")

    # children = [
    #   {Examples.MyGenServer, [name: :counter]}
    # ]

    children = [
      Supervisor.child_spec({MyGenServer, [name: :counter1]}, id: :counter1),
      Supervisor.child_spec({MyGenServer, [name: :counter2]}, id: :counter2),
      Supervisor.child_spec({MyGenServer, [name: :counter3]}, id: :counter3)
    ]

    # More Code that needs to be run before building the tree

    Supervisor.init(children, strategy: :one_for_one)
  end
end
