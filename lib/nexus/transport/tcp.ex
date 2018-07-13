defmodule Nexus.Transport.TCP do
  alias Nexus.Transport
  @behaviour Transport

  @default_opts [:binary, active: false, packet: :raw, reuseaddr: true]

  def listen(port, _provided_opts) do
    # opts = Keyword.merge(@default_opts, provided_opts)
    :gen_tcp.listen(port, @default_opts)
  end

  def accept(socket, timeout) do
    :gen_tcp.accept(socket, timeout)
  end

  def acknowlege(_, _), do: :ok

  def send(socket, payload) do
    :gen_tcp.send(socket, payload)
  end

  def set_opts(socket, opts) do
    :inet.setopts(socket, opts)
  end

  def controlling_process(socket, pid) do
    :gen_tcp.controlling_process(socket, pid)
  end

  def messages, do: {:tcp, :tcp_closed, :tcp_error}

  def peer_name(socket), do: :inet.peername(socket)
end
