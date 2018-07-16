defmodule Nexus.PoolAcceptorSupervisor do
  use Supervisor
  require Logger
  alias Nexus.PoolAcceptor

  def child_spec(config) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [config]},
      type: :supervisor,
      restart: :permanent,
      shutdown: 500
    }
  end

  def start_link(config) do
    Supervisor.start_link(__MODULE__, config, name: __MODULE__)
  end

  def init(config) do
    pool_size = config.pool_size
    {:ok, socket} = config.transport.listen(config.port, config.transport_opts)
    Logger.info("Now listening on port #{config.port}.")
    for id <- 0..pool_size do
      {PoolAcceptor, %{id: id, socket: socket, config: config}}
    end
    |> Supervisor.init(strategy: :one_for_one)
  end
end
