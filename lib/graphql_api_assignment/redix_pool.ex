defmodule GraphqlApiAssignment.RedixPool do
  @default_name :redix_pool
  @default_size 10
  @default_overflow 10

  def child_spec(opts \\ []) do
    name = Keyword.get(opts, :name, @default_name)

    :poolboy.child_spec(name,
      name: {:local, name},
      worker_module: Redix,
      size: opts[:pool_size] || @default_size,
      max_overflow: opts[:max_overflow] || @default_overflow
    )
  end

  def put(key, value, ttl \\ nil, name \\ @default_name)

  @doc """
  Stores a value in the Redis database with an optional time-to-live (TTL).

  ## Parameters

    - `key`: The key under which the value will be stored (binary).
    - `value`: The value to be stored (term).
    - `ttl`: The time-to-live for the key in seconds (integer). If not provided, the key will not expire.
    - `name`: The name of the pool to use (atom). Defaults to `:redix_pool`.

  ## Examples

      iex> GraphqlApiAssignment.RedixPool.put("my_key", "my_value")
      :ok

      iex> GraphqlApiAssignment.RedixPool.put("my_key", "my_value", 3600)
      :ok

  """
  @spec put(binary(), term(), nil | integer(), term()) :: :ok
  def put(key, value, nil, name) do
    :poolboy.transaction(name, fn pid ->
      with {:ok, "OK"} <- Redix.command(pid, ["SET", key, :erlang.term_to_binary(value)]) do
        :ok
      end
    end)
  end

  @spec put(key :: binary(), key :: term(), ttl:: integer(), pool_name :: term()) :: :ok
  def put(key, value, ttl, name) do
    :poolboy.transaction(name, fn pid ->
      with {:ok, "OK"} <- Redix.command(pid, ["SETEX", key, ttl, :erlang.term_to_binary(value)]) do
        :ok
      end
    end)
  end

  @doc """
  Retrieves a value from the Redis database.

  ## Parameters

    - `key`: The key for which the value will be retrieved (binary).
    - `name`: The name of the pool to use (atom). Defaults to `:redix_pool`.

  ## Examples

      iex> GraphqlApiAssignment.RedixPool.get("my_key")
      {:ok, "my_value"}

      iex> GraphqlApiAssignment.RedixPool.get("non_existing_key")
      {:ok, nil}

  """
  @spec get(key :: binary()) :: {:ok, term()}
  @spec get(key :: binary(), pool_name :: term()) :: {:ok, term()}
  def get(key, name \\ @default_name) do
    :poolboy.transaction(name, fn pid ->
      with {:ok, value} <- Redix.command(pid, ["GET", key]) do
        if is_binary(value) do
          {:ok, :erlang.binary_to_term(value)}
        else
          {:ok, value}
        end
      end
    end)
  end
end
