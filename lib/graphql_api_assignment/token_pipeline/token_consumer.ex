defmodule GraphqlApiAssignment.TokenPipeline.TokenConsumer do
  use GenStage

  @default_name __MODULE__

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @default_name)
    GenStage.start_link(__MODULE__, [], opts)
  end

  def init(state) do
    {:consumer, state, subscribe_to: [GraphqlApiAssignment.TokenPipeline.TokenProducer]}
  end

  def handle_events(users, _from, state) do
    for user_id <- users do
      token = generate_token(user_id)
      GraphqlApiAssignment.TokenCache.put(user_id, token)
      IO.puts("Generated token for user #{user_id}: #{token}")
    end
    {:noreply, [], state}
  end

  defp generate_token(user_id) do
    :crypto.strong_rand_bytes(16) |> Base.encode64() |> Kernel.<>("#{user_id}")
  end
end
