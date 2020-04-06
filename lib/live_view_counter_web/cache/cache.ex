defmodule LiveViewCounterWeb.Cache do
  use GenServer

  def start_link(_state) do
    GenServer.start_link(__MODULE__, [], name: LiveViewCounterWeb.Cache)
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def put(key, value) do
    GenServer.cast(__MODULE__, {:put, key, value})
  end

  def init(_stack) do
    {:ok, %{}}
  end

  def handle_call({:get, key}, _from, map) do
    cond do
      Map.has_key?(map, key) -> {:reply, Map.get(map, key), map}
      true -> {:reply, 0, Map.put(map, key, 0)}
    end 
  end

  def handle_cast({:put, key, value}, map) do
    {:noreply, Map.put(map, key, value)}
  end
end