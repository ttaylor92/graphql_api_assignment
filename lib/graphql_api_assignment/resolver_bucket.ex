defmodule GraphqlApiAssignment.ResolverBucket do
  use GenServer

  @default_name __MODULE__
  @table_name :bucket

  def start_link(opts \\ []) do
    table_name = Keyword.get(opts, :table_name, @table_name)
    opts = Keyword.put_new(opts, :name, @default_name)
    GenServer.start(__MODULE__, %{table_name: table_name}, opts)
  end

  # API
  def increment_key(key, name \\ @default_name) do
    GenServer.cast(name, key)
  end

  def get_key_count(key, name \\ @default_name) do
    GenServer.call(name, key)
  end

  @impl true
  def init(%{table_name: table_name}) do
    :ets.new(table_name, [:named_table, read_concurrency: true])
    {:ok, %{table_name: table_name}}
  end

  @impl true
  def handle_call(key, _from, state) do
    case :ets.lookup(state.table_name, key) do
      [{^key, count}] -> {:reply, count, state}
      [] -> {:reply, 0, state}
    end
  end

  @impl true
  def handle_cast(key, state) do
    :ets.update_counter(state.table_name, key, {2, 1}, {key, 0})
    {:noreply, state}
  end
end
