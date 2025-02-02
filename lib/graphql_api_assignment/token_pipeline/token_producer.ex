defmodule GraphqlApiAssignment.TokenPipeline.TokenProducer do
  use GenStage
  alias GraphqlApiAssignment.SchemasPG.AccountManagement

  @default_name __MODULE__
  @deault_interval :timer.hours(24)
  @batch_size 1000

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @default_name)
    interval = Keyword.get(opts, :interval, @deault_interval)
    opts = Keyword.delete(opts, :interval)
    initial_state = %{counter: 0, interval: interval}

    GenStage.start_link(__MODULE__, initial_state, opts)
  end

  def init(state) do
    schedule_next_run(state.interval)
    {:producer, state}
  end

  def handle_demand(demand, state) do
    users = AccountManagement.get_user_ids(demand + (Map.get(state, :counter) || 0))
    last_id = List.last(users)
    {:noreply, users, Map.put(state, :counter, last_id)}
  end

  def handle_cast({:new_user, user_id}, state) do
    # Immediately push new user to consumers
    {:noreply, [user_id], Map.put(state, :counter, user_id)}
  end

  def handle_cast({:dispatch, user_ids}, state) do
    {:noreply, user_ids, Map.put(state, :counter, List.last(user_ids))}
  end

  def handle_info(:run_daily, state) do
    IO.puts("Starting daily user processing...")
    process_all_users(state.counter)
    schedule_next_run(state.interval)
    {:noreply, [], state}
  end

  defp process_all_users(offset) do
    user_ids = AccountManagement.get_user_ids(@batch_size, offset)

    if user_ids != [] do
      GenServer.cast(__MODULE__, {:dispatch, user_ids})
      process_all_users(offset + @batch_size)  # Fetch next batch
    else
      IO.puts("All users processed for today.")
    end
  end

  def new_user_registered(user_id) do
    GenServer.cast(__MODULE__, {:new_user, user_id})
  end

  defp schedule_next_run(interval) do
    Process.send_after(__MODULE__, :run_daily, interval)
  end
end
