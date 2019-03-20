defmodule StreamlabsIntro.StreamRouter do

  use GenServer
  require Logger

  alias StreamlabsIntro.{Streamers, Streamer}

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(map) do
    {:ok, map}
  end

  @impl true
  def handle_call({:get, id}, _from, state) do
    {:reply, Map.get(state, id), state}
  end

  @impl true
  def handle_cast({:subscribe, socket, id}, state) do
    case Map.get(state, id) do
      nil ->
        twitch_sub = Task.async(fn -> Twitch.sub_to_streamer(id) end)
        {:ok, streamer} = DynamicSupervisor.start_child(Streamers, Streamer)
        streamer |> Streamer.subscribe(socket)
        Task.await(twitch_sub)
        Process.monitor(socket)
        {:noreply, Map.put(state, id, streamer)}
      streamer ->
        Process.monitor(socket)
        streamer |> Streamer.subscribe(socket)
        {:noreply, state}
    end
  end
  def handle_cast({:cleanup, pid}, state) do
    id = Enum.find(state, fn {_, val} -> val == pid end) |> elem(0)
    Twitch.sub_to_streamer(id, true)
    GenServer.stop(pid)
    {:noreply, Map.delete(state, id)}
  end

  @impl true
  def handle_info({:DOWN, _, :process, pid, _}, state) do
    for streamer <- Enum.map(state, fn {_, v} -> v end) do
      Streamer.unsubscribe(streamer, pid)
    end
    {:noreply, state}
  end
  def handle_info(_, state), do: {:noreply, state}

  def get(id), do: GenServer.call(__MODULE__, {:get, id})

  def subscribe(socket, id) do
    GenServer.cast(__MODULE__, {:subscribe, socket, id})
  end

  def cleanup(pid) do
    GenServer.cast(__MODULE__, {:cleanup, pid})
  end

end
