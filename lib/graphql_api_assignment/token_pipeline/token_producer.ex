defmodule GraphqlApiAssignment.TokenPipeline.TokenProducer do
  use GenStage
  alias GraphqlApiAssignment.SchemasPG.AccountManagement

  @default_name __MODULE__
  @interval :timer.hours(24)
  @batch_size 1000

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @default_name)
    initial_state = 0
    GenStage.start_link(__MODULE__, initial_state, opts)
  end

  def init(state) do
    schedule_next_run()
    {:producer, state}
  end

  def handle_demand(demand, state) do
    users = AccountManagement.get_user_ids(demand + state)
    last_id = List.last(users)
    {:noreply, users, last_id}
  end

  def handle_cast({:new_user, user_id}, _state) do
    # Immediately push new user to consumers
    {:noreply, [user_id], user_id}
  end

  def handle_cast({:dispatch, user_ids}, _state) do
    {:noreply, user_ids, List.last(user_ids)}
  end

  def handle_info(:run_daily, state) do
    IO.puts("Starting daily user processing...")
    process_all_users(0)  # Start fetching users from offset 0
    schedule_next_run()
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

  defp schedule_next_run do
    Process.send_after(__MODULE__, :run_daily, @interval)
  end
end
