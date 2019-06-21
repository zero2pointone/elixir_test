defmodule Ranchtest.Client do
  use GenServer
  require Logger

  @name :client

  def start_link(args, opts \\ []) do
    opts = Enum.concat(opts, name: @name)
    GenServer.start_link(__MODULE__, args, opts)
  end

  def init(_state) do
    Logger.debug("Client.init")
    {:ok, %{}}
  end

  def send(msg) do
    GenServer.call(@name, {:send, msg})
  end

  def receive() do
    GenServer.call(@name, :receive)
  end

  def close() do
    GenServer.cast(@name, :close)
  end

  def connect() do
    GenServer.cast(@name, :connect)
  end

  def handle_call({:send, data}, _from, %{socket: socket} = state) do
    socket |> Socket.Stream.send!(data)
    {:reply, "send successfully!", state}
  end

  def handle_call(:receive, _from, %{socket: socket} = state) do
    {:reply, Socket.Stream.recv!(socket), state}
  end

  def handle_call(_, _from, state) do
    {:reply, "wrong call!", state}
  end

  def handle_cast(:connect, state) do
    socket = Socket.TCP.connect!("127.0.0.1", 4567)
    {:noreply, Map.put(state, :socket, socket)}
  end

  def handle_cast(:close, %{socket: socket} = state) do
    Socket.close!(socket)
    {:noreply, Map.drop(state, [:socket])}
  end

  def handle_cast(_, state) do
    {:noreply, state}
  end

  def handle_info(_, _from, state) do
    {:reply, "wrong info!", state}
  end
end
