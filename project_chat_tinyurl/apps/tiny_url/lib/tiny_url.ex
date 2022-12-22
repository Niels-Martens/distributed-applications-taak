defmodule TinyURL do
  @moduledoc """
  ##Example 
        iex(1)> {:ok, pid} = TinyURL.start_link(:foo)
        {:ok, #PID<0.109.0>}
  
        iex(2)> TinyURL.shorten(:foo, "https://google.com")
        "99999ebcfdb78df077ad2727fd00969f"
  
        iex(3)> TinyURL.get(:foo, "99999ebcfdb78df077ad2727fd00969f")
        "https://google.com"
  
        iex(4)> TinyURL.stop(:foo)
        :ok
  
        iex(5)> Process.alive?(pid)
        false
        Chat.shorten_url("https://google.com")
  """
  use GenServer

  # Client API
  def start_link(name, opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: name])
  end

  def shorten(name, url) do
    GenServer.call(name, {:shorten, url})
  end

  def get(name, short) do
    GenServer.call(name, {:get, short})
  end

  def flush(name) do
    GenServer.cast(name, :flush)
  end

  def stop(name) do
    GenServer.cast(name, :stop)
  end

  def count(name) do
    GenServer.call(name, :count)
  end

  # Callbacks
  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast(:flush, _state) do
    {:noreply, %{}}
  end

  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  def handle_call({:shorten, url}, _from, state) do
    shortened = md5(url)
    new_state = Map.put(state, shortened, url)
    {:reply, shortened, new_state}
  end

  def handle_call({:get, short}, _from, state) do
    {:reply, Map.get(state, short), state}
  end

  def handle_call(:count, _from, state) do
    count = Map.keys(state) |> Enum.count()
    {:reply, count, state}
  end

  defp md5(url) do
    :crypto.hash(:md5, url)
    |> Base.encode16(case: :lower)
  end
end
