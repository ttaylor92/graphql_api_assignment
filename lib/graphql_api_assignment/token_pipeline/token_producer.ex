defmodule GraphqlApiAssignment.TokenPipeline.TokenProducer do
  use GenStage
  alias GraphqlApiAssignment.SchemasPG.AccountManagement

  @default_name __MODULE__

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @default_name)
    GenStage.start_link(__MODULE__, [], opts)
  end

  def init(state) do
    {:producer, state}
  end

  def handle_demand(demand, _state) do
    users = AccountManagement.get_user_ids(demand)
    {:noreply, users, []}
  end
end
