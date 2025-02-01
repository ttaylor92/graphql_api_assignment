defmodule GraphqlApiAssignment.TokenPipeline.TokenProducer do
  use GenStage
  alias GraphqlApiAssignment.SchemasPG.AccountManagement

  @default_name __MODULE__

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @default_name)
    initial_state = 0
    GenStage.start_link(__MODULE__, initial_state, opts)
  end

  def init(state) do
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

  def new_user_registered(user_id) do
    GenServer.cast(__MODULE__, {:new_user, user_id})
  end
end
