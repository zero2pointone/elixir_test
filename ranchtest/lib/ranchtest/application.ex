defmodule Ranchtest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Ranchtest.Worker.start_link(arg)
      # {Ranchtest.Worker, arg}
      # %{
      #   id: Ranchtest.Client.Supervisor,
      #   start: {Ranchtest.Client.Supervisor, :start_link, []},
      #   type: :supervisor
      # }
      Ranchtest.Client
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ranchtest.Supervisor]
    Supervisor.start_link(children, opts)
    bootstrap()
  end

  defp bootstrap() do
    port = 4567

    {:ok, _} =
      :ranch.start_listener(make_ref(), :ranch_tcp, [{:port, port}], Ranchtest.Session, [])
  end
end
