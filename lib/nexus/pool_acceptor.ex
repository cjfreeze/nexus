defmodule Nexus.PoolAcceptor do
  alias Nexus.PoolAcceptor

  def child_spec(%{id: id, socket: socket, config: config}) do
    %{
      id: id,
      start: {PoolAcceptor, :start_link, [socket, config]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  def init(socket, config) do
    %{
      socket: socket,
      transport: config.transport,
      handler: config.handler,
      config: config
    }
  end

  def start_link(socket, config) do
    state = init(socket, config)
    pid = Process.spawn(fn -> accept(state) end, [])
    Process.link(pid)
    {:ok, pid}
  end

  defp accept(%{transport: transport, socket: socket} = state) do
    socket
    |> transport.accept(:infinity)
    |> handle_accept(state)
    accept(state)
  end

  defp handle_accept({:ok, socket}, %{handler: handler, transport: transport, config: %{state: state}}) do
    {:ok, pid} = handler.start_handling_process(socket, transport, state)
    transport.controlling_process(socket, pid)
  end
end
