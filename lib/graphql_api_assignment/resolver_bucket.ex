defmodule GraphqlApiAssignment.ResolverBucket do
  use Agent

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
    Agent.start_link(fn -> initial_state end, opts)
  end

  # Increment functions
  def increment_create_user(name \\ @default_name) do
    increment_key(name, :create_user)
  end

  def increment_update_user(name \\ @default_name) do
    increment_key(name, :update_user)
  end

  def increment_update_user_preferences(name \\ @default_name) do
    increment_key(name, :update_user_preferences)
  end

  def increment_get_user(name \\ @default_name) do
    increment_key(name, :get_user)
  end

  def increment_get_users(name \\ @default_name) do
    increment_key(name, :get_users)
  end

  # Retrieve count functions
  def get_create_user_count(name \\ @default_name) do
    get_key_count(name, :create_user)
  end

  def get_update_user_count(name \\ @default_name) do
    get_key_count(name, :update_user)
  end

  def get_update_user_preferences_count(name \\ @default_name) do
    get_key_count(name, :update_user_preferences)
  end

  def get_user_count(name \\ @default_name) do
    get_key_count(name, :get_user)
  end

  def get_users_count(name \\ @default_name) do
    get_key_count(name, :get_users)
  end

  # Private helpers
  defp increment_key(name, key) do
    Agent.update(name, fn state -> Map.update(state, key, 0, &(&1 + 1)) end)
  end

  defp get_key_count(name, key) do
    Agent.get(name, &Map.get(&1, key))
  end
end
