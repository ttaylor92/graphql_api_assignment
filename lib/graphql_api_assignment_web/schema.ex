defmodule GraphqlApiAssignmentWeb.Schema do
  use Absinthe.Schema

  alias GraphqlApiAssignmentWeb.Schema.{Queries, Mutations, Subscriptions}
  alias GraphqlApiAssignmentWeb.Types

  import_types Types.{UserInputType, UserResponseType, BucketInputType}
  import_types Queries.{UserQuery, BucketQuery}
  import_types Mutations.UserMutation
  import_types Subscriptions.UserSubscription

  query do
    import_fields :user_queries
    import_fields :resolver_queries
  end

  mutation do
    import_fields :user_mutations
  end

  subscription do
    import_fields :user_subscriptions
  end
end
