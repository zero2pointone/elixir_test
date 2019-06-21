defmodule Ranchtest.Session do
  use GenServer
  require Logger

  def start_link(ref, socket, transport, _opts) do
    {:ok, :proc_lib.spawn_link(__MODULE__, :init, [{ref, socket, transport}])}
  end

  def init({ref, socket, transport}) do
    Logger.debug("session.init")
    :ok = :ranch.accept_ack(ref)
    :ok = transport.setopts(socket, [{:active, true}])
    :gen_server.enter_loop(__MODULE__, [], %{socket: socket, transport: transport})
  end

  def handle_info({:tcp, _socket, packet}, %{socket: socket, transport: transport} = state) do
    Logger.debug("packet is #{inspect(packet, pretty: true)}")
    Logger.debug("state is #{inspect(state, pretty: true)}")

    transport.send(socket, packet)
    {:noreply, state}
  end

  def handle_info({:tcp_closed, socket}, %{transport: transport} = state) do
    Logger.debug("handle_info({:tcp_closed -------------------------")
    transport.close(socket)
    {:stop, :normal, state}
  end

  def handle_info({:tcp_error, _, reason}, state) do
    Logger.debug("handle_info({:tcp_error -------------------------")
    {:stop, reason, state}
  end

  def handle_info(:timeout, state) do
    Logger.debug("handle_info({:timeout -------------------------")
    {:stop, :normal, state}
  end

  def handle_info({:inet_reply, _, _}, state) do
    Logger.debug("handle_info({:inet_reply -------------------------")
    {:noreply, state}
  end

  def handle_info({:stop, reason}, state) do
    Logger.debug("handle_info({:stop -------------------------")
    Logger.info("reason is #{inspect(reason, pretty: true)}")
    {:stop, reason, state}
  end

  def handle_info(:server_close, state) do
    Logger.debug("handle_info({:server_close -------------------------")
    Logger.info("server actively close connection #{inspect(state, pretty: true)}")

    {:stop, :normal, state}
  end

  def handle_info(:ping_timeout, state) do
    Logger.debug("handle_info({:ping_timeout -------------------------")
    Logger.info("this player ping timeout, state is #{inspect(state)}")
    {:stop, :normal, state}
  end

  def handle_info({:EXIT, _, :shutdown}, state) do
    Logger.debug("handle_info({:EXIT -------------------------")
    {:stop, :shutdown, state}
  end

  def handle_info(info, state) do
    Logger.debug("handle_info({info -------------------------")
    Logger.info(fn -> "unexcpeted session info #{inspect(info)}" end)
    {:stop, :normal, state}
  end
end
