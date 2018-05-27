defmodule Nexus.Transport do
  @type socket :: pid
  @callback listen(integer, list) :: {:ok, socket} | {:error, any}
  @callback accept(socket, integer) :: {:ok, socket} | {:error, any}
  @callback set_opts(socket, integer) :: {:ok, socket} | {:error, any}
  @callback controlling_process(socket, pid) :: :ok | {:error, atom}
  @callback messages :: {atom, atom, atom}
end
