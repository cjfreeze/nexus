defmodule Nexus.Config do
  alias Nexus.Config

  defstruct [
    transport: nil,
    pool_size: 10,
    port: 0,
    transport_opts: [],
    handler: nil,
    state: nil,
  ]

  def init(config) do
    :ets.new(Config, [:set, :public, :named_table])
    Config
    |> struct(config)
    |> set_all()
    get_all()
  end

  def set_all(%Config{} = config) do
    :ets.insert(__MODULE__, {:config, config})
  end

  def get_all do
    :ets.lookup_element(__MODULE__, :config, 2)
  end

  def set(key, val) do
    get_all()
    |> Map.put(key, val)
    |> set_all()
  end

  def get(key) do
    get_all()
    |> Map.get(key)
  end
end
