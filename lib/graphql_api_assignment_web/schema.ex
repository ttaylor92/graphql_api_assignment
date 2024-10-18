defmodule GraphqlApiAssignmentWeb.Schema do
  use Absinthe.Schema

  alias GraphqlApiAssignmentWeb.Schema.{Queries, Mutations, Subscriptions}
  alias GraphqlApiAssignmentWeb.Types.{UserInputType, UserResponseType}

  import_types UserInputType
  import_types UserResponseType
  import_types Queries.UserQuery
  import_types Mutations.UserMutation
  import_types Subscriptions.UserSubscription

  query do
    import_fields :user_queries
  end

  mutation do
    import_fields :user_mutations
  end

  subscription do
    import_fields :user_subscriptions
  end
end
