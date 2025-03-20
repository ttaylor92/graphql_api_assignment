defmodule GraphqlApiAssignment.HashringCache do
  use Task, restart: :permanent

  @hash_ring_name :default_hash_cache
  @ets_options [:public, :set, :named_table]
  @replica_count 2

  def hash_ring_name, do: @hash_ring_name

  def start_link(opts) do
    opts = Keyword.put_new(opts, :name, @hash_ring_name)

    Task.start_link(fn ->
      setup(opts)
    end)
  end

  def setup(opts) do
    :ets.new(table_name(opts[:name]), @ets_options)
    Process.hibernate(Function, :identity, [])
  end

  def put(hash_ring \\ @hash_ring_name, key, value) do
    hash_ring
    |> key_to_node(key)
    |> Enum.each(&:erpc.cast(&1, fn ->
        hash_ring
        |> table_name()
        |> :ets.insert({key, value})
      end)
    )
  end

  def get(hash_ring \\ @hash_ring_name, key) do
    hash_ring
    |> key_to_node(key)
    |> Enum.random()
    |> :erpc.call(fn ->
      res =
        hash_ring
        |> table_name()
        |> :ets.lookup(key)

      case res do
        [{_, value}] -> value
        _ -> nil
      end
    end)
  end

  def key_to_node(hash_ring \\ @hash_ring_name, key) do
    HashRing.Managed.key_to_nodes(hash_ring, key, @replica_count)
  end

  def table_name(hash_ring), do: :"#{hash_ring}_ets"
end
