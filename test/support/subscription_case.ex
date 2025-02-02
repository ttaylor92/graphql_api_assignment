defmodule GraphqlApiAssignmentWeb.Support.SubscriptionCase do
  @moduledoc """
  Test Case for GraphQL subscription
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      use GraphqlApiAssignmentWeb.Support.ChannelCase

      use Absinthe.Phoenix.SubscriptionTest,
        schema: GraphqlApiAssignmentWeb.Schema
    end
  end
end
