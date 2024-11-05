defmodule GraphqlApiAssignmentWeb.Schema do
  use Absinthe.Schema

  alias GraphqlApiAssignment.SchemasPG.AccountManagement.{Preference, User}
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

  def context(context) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(User, User.data())
      |> Dataloader.add_source(Preference, Preference.data())

    Map.put(context, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
