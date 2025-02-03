defmodule GraphqlApiAssignment.TokenPipeline.TokenProducerConsumer do
  use GenStage
  alias GraphqlApiAssignment.TokenPipeline

  @default_name __MODULE__

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @default_name)
    GenStage.start_link(__MODULE__, [], opts)
  end

  def init(state) do
    {:producer_consumer, state, subscribe_to: [TokenPipeline.TokenProducer]}
  end

  def handle_events(users, _from, state) do
    user_tokens = Enum.map(users, fn user_id ->
      token = generate_token(user_id)
      IO.puts("Generated token for user #{user_id}")
      {user_id, token}
    end)
    {:noreply, user_tokens, state}
  end

  defp generate_token(user_id) do
    16
    |> :crypto.strong_rand_bytes()
    |> Base.encode64()
    |> Kernel.<>("#{user_id}")
  end
end
