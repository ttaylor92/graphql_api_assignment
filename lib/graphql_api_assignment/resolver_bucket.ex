defmodule GraphqlApiAssignment.ResolverBucket do
  use Agent

  @default_name __MODULE__

  # API
  def start_link(opts \\ []) do
    initial_state = %{}
    opts = Keyword.put_new(opts, :name, @default_name)
    Agent.start_link(fn -> initial_state end, opts)
  end

  # API
  def increment_key(key, name \\ @default_name) do
    Agent.update(name, fn state -> Map.update(state, key, 1, &(&1 + 1)) end)
  end

  def get_key_count(key, name \\ @default_name) do
    Agent.get(name, &Map.get(&1, key, 0))
  end
end
