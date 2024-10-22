defmodule GraphqlApiAssignmentWeb.Resolvers.UserResolver do
  alias GraphqlApiAssignment.UserService

  def get_user_by_id(_, %{id: id}, _) do
    UserService.get_user_by_id(id)
  end

  def create_user(_, args, _) do
    UserService.create_user(args)
  end

  def get_users_by_preferences(_, args, _) do
    UserService.get_users(args)
  end

  def update_a_user(_, args, _) do
    UserService.update_a_user(args)
  end

  def update_user_preference(_, args, _) do
    UserService.update_user_preference(args)
  end

  def create_user_trigger_topic(_) do
    "new_user"
  end

  def create_user_subscription_config(_, _) do
    {:ok, topic: "new_user"}
  end

  def update_user_preference_topic(preference_response) do
    preference_response.user_id
  end

  def update_user_preference_subscription_config(preference_response, _) do
    {:ok, topic: preference_response.user_id}
  end
end
