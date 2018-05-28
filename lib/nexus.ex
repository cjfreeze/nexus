defmodule Nexus do
  alias Nexus.{
    Config,
    PoolAcceptorSupervisor,
    Transport.SSL,
    Transport.TCP,
  }

  def start_tcp(port, handler, nexus_opts \\ [], state \\ nil) do
    :nexus
    |> Application.get_env(:tcp_transport, TCP)
    |> do_start(port, handler, nexus_opts, state)
  end

  def start_ssl(port, handler, nexus_opts \\ [], state \\ nil) do
    :nexus
    |> Application.get_env(:ssl_transport, SSL)
    |> do_start(port, handler, nexus_opts, state)
  end

  defp do_start(transport, port, handler, opts, state) do
    transport
    |> do_init(port, handler, opts, state)
    |> PoolAcceptorSupervisor.start_link()
  end

  def child_spec_tcp(port, handler, nexus_opts, state) do
    :nexus
    |> Application.get_env(:tcp_transport, TCP)
    |> do_child_spec(port, handler, nexus_opts, state)
  end

  def child_spec_ssl(port, handler, nexus_opts, state) do
    :nexus
    |> Application.get_env(:ssl_transport, SSL)
    |> do_child_spec(port, handler, nexus_opts, state)
  end

  defp do_child_spec(transport, port, handler, opts, state) do
    transport
    |> do_init(port, handler, opts, state)
    |> PoolAcceptorSupervisor.child_spec()
  end

  defp do_init(transport, port, handler, opts, state) do
    pool_size = Keyword.get(opts, :pool_size, 10)
    transport_opts = Keyword.get(opts, :transport_opts, [])
    %{
      port: port,
      transport: transport,
      handler: handler,
      pool_size: pool_size,
      transport_opts: transport_opts,
      state: state
    }
    |> Config.init()
  end

  def acknowlege do
    receive do
      {:pre_ack, transport, socket, timeout} ->
        transport.acknowlege(socket, timeout)
    end
  end
end
