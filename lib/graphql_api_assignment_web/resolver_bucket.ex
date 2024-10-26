defmodule GraphqlApiAssignmentWeb.ResolverBucket do
  use GenServer

  @default_name __MODULE__

  # API
  def start_link(opts \\ []) do
    initial_state = %{
      create_user: 0,
      update_user: 0,
      update_user_preferences: 0,
      get_user: 0,
      get_users: 0
    }
    opts = Keyword.put_new(opts, :name, @default_name)
    GenServer.start_link(__MODULE__, initial_state, opts)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  # Server
  @impl true
  def handle_cast(key, state) do
    updated_state = Map.update(state, key, 1, fn value -> value + 1 end)
    {:noreply, updated_state}
  end

  @impl true
  def handle_call(key, _from, state) do
    {:reply, Map.get(state, key), state}
  end

  # API
  def increment_create_user(name \\ @default_name) do
    GenServer.cast(name, :create_user)
  end

  def increment_update_user(name \\ @default_name) do
    GenServer.cast(name, :update_user)
  end

  def increment_update_user_preferences(name \\ @default_name) do
    GenServer.cast(name, :update_user_preferences)
  end

  def increment_get_user(name \\ @default_name) do
    GenServer.cast(name, :get_user)
  end

  def increment_get_users(name \\ @default_name) do
    GenServer.cast(name, :get_users)
  end

  def get_create_user_count(name \\ @default_name) do
    GenServer.call(name, :create_user)
  end

  def get_update_user_count(name \\ @default_name) do
    GenServer.call(name, :update_user)
  end

  def get_update_user_preferences_count(name \\ @default_name) do
    GenServer.call(name, :update_user_preferences)
  end

  def get_user_count(name \\ @default_name) do
    GenServer.call(name, :get_user)
  end

  def get_users_count(name \\ @default_name) do
    GenServer.call(name, :get_users)
  end
end
