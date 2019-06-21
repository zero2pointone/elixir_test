defmodule Client do
  @moduledoc """
  Documentation for Client.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Client.hello()
      :world

  """
  def hello do
    :world
  end

  #####################################################################


  use GenServer
  require Logger



  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    connect_socket = connect()
    {:ok, %{connect_socket: connect_socket}}
  end

  def cast(request) do
    GenServer.cast(__MODULE__, request)
  end

  def call(request) do
    GenServer.call(__MODULE__, request)
  end

  def req_info(request, delay \\ 0) do
    Process.send_after(__MODULE__, request, delay)  #发信息给handle_info
  end

  def handle_cast({:send, msg}, %{connect_socket: connect_socket} = state) do
    Logger.debug("coming here : handle_cast({:send, msg}")
    case :gen_tcp.send(connect_socket, msg) do        #################
      :ok ->
        Logger.debug(":gen_tcp.send(connect_socket, msg) -> ok")
        {:noreply, state}

      err ->
        Logger.debug(fn -> "gen_tcp send err:#{inspect err}\n,
          tcp_connect, try again" end)
        tcp_connect()
        {:noreply, state |> Map.delete(:connect_socket)}
      _ ->
         Logger.debug("handle_cast({:send, msg}, %{connect_socket: connect_socket} = state)  case match _")
         {:noreply, state}
    end
  end

  def handle_cast(:tcp, %{connect_socket: connect_socket} = state) do
    Logger.debug("coming here : handle_cast(:tcp, %{connect_socket: connect_socket} = state)")
    msg = 'abcdef'
    #[mod, func, args] |> :erlang.term_to_binary()
    databag = ["{" ,:tcp, "," ,connect_socket,"," ,msg, "}"] |> :erlang.term_to_binary()
    Logger.debug("here")
    #:erlang.term_to_binary()
    case :gen_tcp.send(connect_socket, databag) do        #################
      :ok ->
        Logger.debug(":gen_tcp.send(connect_socket, msg) -> ok")
        {:noreply, state}

      err ->
        Logger.debug(fn -> "gen_tcp send err:#{inspect err}\n,
          tcp_connect, try again" end)
        tcp_connect()
        {:noreply, state |> Map.delete(:connect_socket)}
      _ ->
         Logger.debug("handle_cast({:send, msg}, %{connect_socket: connect_socket} = state)  case match _")
         {:noreply, state}
    end
  end

  def handle_cast(msg, state) do
    Logger.debug(fn -> "handle_cast msg:#{inspect msg}\n" end)
    {:noreply, state}
  end

  def handle_call(msg, from, state) do
    Logger.debug(fn -> "handle_call msg:#{inspect msg}\n" end)


    {:noreply, state}
  end

  def handle_info({:tcp_connect}, state) do
    Logger.debug("handle_info({:tcp_connect}, state)")
    {:noreply, state |> Map.merge(%{connect_socket: connect()})}
  end

  def handle_info({:tcp_connect, ip, port}, state) do
    Logger.debug("handle_info({:tcp_connect, ip, port}, state)")
    {:noreply, state |> Map.merge(%{connect_socket: connect(ip, port)})}
  end

  def handle_info({:tcp, _socket, msg}, %{connect_socket: _connect_socket} = state) do
    Logger.debug("handle_info({:tcp, _socket, msg}, %{connect_socket: _connect_socket} = state) ")
    msg = decode(msg)
    Logger.debug(fn -> "receive msg:\n #{inspect msg}\n" end)
    {:noreply, state}
  end

  def handle_info({:tcp_closed, socket}, state) do
    Logger.debug("handle_info({:tcp_closed, socket}, state)")
    :gen_tcp.close(socket)
    {:noreply, state}
  end

  def handle_info({:error, socket, reason}, state) do
    Logger.debug("handle_info({:error, socket, reason}, state)")
    :gen_tcp.close(socket)
    Logger.debug(fn -> "receive msg error reason:#{inspect reason}\n" end)
    {:noreply, state}
  end

  def handle_info({:closed}, %{connect_socket: connect_socket} = state) do
    Logger.debug("handle_info({:closed}, %{connect_socket: connect_socket} = state)")
    :gen_tcp.close(connect_socket)
    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.debug("handle_info(msg, state)")
    Logger.debug(fn -> "handle_info msg:#{inspect msg}\n" end)
    {:noreply, state}
  end

  def terminate(state) do# 终止
      state
  end

  # Client.send(Test, :test0, [1,2,3])
  def send(mod, func, args \\ []) do
    msg = encode(mod, func, args)
    cast({:send, msg})
  end

  def sendtcp() do
    cast(:tcp)
  end


  # def mysend() do
  #   call(:send)
  # end

  def tcp_connect() do
    close()
    req_info({:tcp_connect}, 0)
  end

  def tcp_connect(ip, port) do
    close()
    req_info({:tcp_connect, ip, port}, 0)
  end

  def close(delay \\ 0) do
    req_info({:closed}, delay)
  end

  defp encode(mod, func, args) do
    [mod, func, args] |> :erlang.term_to_binary()
  end

  defp decode(msg) do
    :erlang.binary_to_term(msg)
  end

  defp connect() do
    ip = Application.get_env(:my_client, :ip, {192, 168, 1, 132})
    port = Application.get_env(:my_client, :port, 3256)
	# connect(Address, Port, Options, Timeout) -> {ok, Socket} | {error, Reason}
    {:ok, connect_socket} = :gen_tcp.connect(ip, port, [:binary, {:packet, 0}])
    Logger.debug(fn -> "1 connect_socket:#{inspect connect_socket}" end)
    connect_socket
  end

  defp connect(ip, port) do
    {:ok, connect_socket} = :gen_tcp.connect(ip, port, [:binary, {:packet, 0}])
    Logger.debug(fn -> "2 connect_socket:#{inspect connect_socket}" end)
    connect_socket
  end





end
