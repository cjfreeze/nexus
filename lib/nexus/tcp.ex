defmodule Nexus.TCP do
  alias Nexus.Transport
  @behaviour Transport

  def listen(port, _opts) do
    :gen_tcp.listen(port, [:binary, active: false, packet: :raw, reuseaddr: true])
  end

  def accept(socket, timeout) do
    :gen_tcp.accept(socket, timeout)
  end

  def set_opts(socket, opts) do
    :inet.setopts(socket, opts)
  end

  def controlling_process(socket, pid) do
    :gen_tcp.controlling_process(socket, pid)
  end

  def messages, do: {:tcp, :tcp_closed, :tcp_error}
end
