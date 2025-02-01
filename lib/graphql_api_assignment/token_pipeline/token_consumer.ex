defmodule GraphqlApiAssignment.TokenPipeline.TokenConsumer do
  use GenStage
  alias GraphqlApiAssignment.TokenPipeline

  @default_name __MODULE__

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @default_name)
    GenStage.start_link(__MODULE__, [], opts)
  end

  def init(state) do
    {:consumer, state, subscribe_to: [TokenPipeline.TokenProducerConsumer]}
  end

  def handle_events(user_tokens, _from, state) do
    for {user_id, token} <- user_tokens do
      GraphqlApiAssignment.TokenCache.put(user_id, token)
      IO.puts("Added token for user #{user_id}")
    end
    {:noreply, [], state}
  end
end
