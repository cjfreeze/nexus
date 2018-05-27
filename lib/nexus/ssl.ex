defmodule Nexus.SSL do
  alias Nexus.Transport
  @behaviour Transport

  def listen(port, _opts) do
    :ssl.listen(port, [:binary, active: false, packet: :raw, reuseaddr: true])
  end

  def accept(socket, timeout) do
    :ssl.ssl_accept(socket, timeout)
  end

  def set_opts(socket, opts) do
    :ssl.setopts(socket, opts)
  end

  def controlling_process(socket, pid) do
    :ssl.controlling_process(socket, pid)
  end

  def messages, do: {:ssl, :ssl_closed, :ssl_error}
end
