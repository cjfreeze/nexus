# defmodule Nexus.Application do
#   use Application

#   def start(_type, _args) do
#     children = [
#       {Nexus.PoolAcceptorSupervisor, []},
#     ]

#     opts = [strategy: :one_for_one, name: Nexus.Supervisor]
#     Supervisor.start_link(children, opts)
#   end
# end
