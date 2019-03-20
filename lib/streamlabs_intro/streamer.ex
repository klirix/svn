defmodule StreamlabsIntro.Streamer do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  @impl true
  def init(_) do
    {:ok, []}
  end

  @impl true
  def handle_cast({:event, data}, state) do
    IO.inspect("Got event, dispatching")
    IO.inspect(["Streamer",data])
    for socket <- state, do: send(socket, {:stream_event, data})
    {:noreply, state}
  end
  def handle_cast({:subscribe, socket}, state) do
    IO.puts("Streamer: being subbed to")
    {:noreply, [socket | state]}
  end
  def handle_cast({:unsubscribe, socket}, state) do
    case List.delete(state, socket) do
      [] ->
        StreamlabsIntro.StreamRouter.cleanup(self())
        {:noreply, []}
      res ->
        {:noreply, res}
    end
  end

  def event(streamer, event) do
    GenServer.cast(streamer, {:event, event})
  end

  def subscribe(streamer, socket) do
    GenServer.cast(streamer, {:subscribe, socket})
  end
  def unsubscribe(streamer, socket) do
    GenServer.cast(streamer, {:unsubscribe, socket})
  end
end
