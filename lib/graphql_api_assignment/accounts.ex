defmodule GraphqlApiAssignment.Accounts do
  @moduledoc """
  The Accounts context.

  This context is responsible for managing user accounts, including creation,
  retrieval, updating, and deletion of user data.
  """
  alias EctoShorts.{Actions, CommonFilters}
  alias GraphqlApiAssignment.Accounts.User
  alias GraphqlApiAssignment.Accounts.Preference

  def create_user(params) do
    Actions.create(User, params)
  end

  def get_user(id) do
    Actions.get(User, id)
  end

  def update_user(id, params) do
    Actions.update(User, id, params)
  end

  def delete_user(id) do
    Actions.delete(User, id)
  end

  def create_user_preference(params) do
    Actions.create(Preference, params)
  end

  def update_user_preference(id, params) do
    Actions.update(Preference, id, params)
  end

  def get_users(params) do
    CommonFilters.convert_params_to_filter(User, params)
    |> Actions.all(preload: :preferences)
  end
end
