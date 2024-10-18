defmodule GraphqlApiAssignmentWeb.Resolvers.UserResolver do
  alias GraphqlApiAssignmentWeb.Services.UserService

  def get_user_by_id(_, %{id: id}, _) do
    UserService.get_user_by_id(id)
  end

  def create_user(_, args, _) do
    UserService.create_user(args)
  end

  def get_users_by_preferences(_, args, _) do
    UserService.get_users_by_preferences(args)
  end

  def update_a_user(_, args, _) do
    UserService.update_a_user(args)
  end

  def update_user_preference(_, args, _) do
    UserService.update_user_preference(args)
  end
end
