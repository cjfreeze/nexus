defmodule Nexus.SSL do
  alias Nexus.Transport
  @behaviour Transport

  def listen(port, opts) do
    :ssl.start()
    keyfile = Keyword.fetch!(opts, :keyfile)
    certfile = Keyword.fetch!(opts, :certfile)
    File.exists?(keyfile) || raise "Keyfile does not exist)"
    File.exists?(certfile) || raise "Certfile does not exist)"
    opts = [
      :binary,
      keyfile: keyfile,
      certfile: certfile,
      ciphers: :ssl.cipher_suites(),
      active: false,
      packet: :raw,
      reuseaddr: true,
      backlog: 1024,
      nodelay: true,
    ]
    :ssl.listen(port, opts)
  end

  def accept(socket, timeout) do
    :ssl.transport_accept(socket, timeout)
  end

  def acknowlege(socket, timeout) do
    :ssl.ssl_accept(socket, timeout)
  end

  def send(socket, payload) do
    :ssl.send(socket, payload)
  end

  def set_opts(socket, opts) do
    :ssl.setopts(socket, opts)
  end

  def controlling_process(socket, pid) do
    :ssl.controlling_process(socket, pid)
  end

  def messages, do: {:ssl, :ssl_closed, :ssl_error}

  def peer_name(socket), do: :ssl.peername(socket)
end
