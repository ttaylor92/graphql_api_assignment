defmodule GraphqlApiAssignmentWeb.Resolvers.BucketResolver do
  alias GraphqlApiAssignment.ResolverBucket

  def get_resolver_hits(_, %{key: key}, _) do
    case key do
      "create_user" -> {:ok, ResolverBucket.get_create_user_count()}
      "get_user" -> {:ok, ResolverBucket.get_user_count()}
      "get_users" -> {:ok, ResolverBucket.get_users_count()}
      "update_user" -> {:ok, ResolverBucket.get_update_user_count()}
      "update_user_preferences" -> {:ok, ResolverBucket.get_update_user_preferences_count()}
    end
  end
end
