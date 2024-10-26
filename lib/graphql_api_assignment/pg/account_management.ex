defmodule GraphqlApiAssignment.Pg.AccountManagement do
  @moduledoc """
  The Accounts context.

  This context is responsible for managing user accounts, including creation,
  retrieval, updating, and deletion of user data.
  """
  alias EctoShorts.{Actions, CommonFilters}
  alias GraphqlApiAssignment.Pg.AccountManagement.{User, Preference}
  alias GraphqlApiAssignment.Repo

  def create_user(params) do
    Actions.create(User, params)
  end

  def get_user(id, opts \\ []) do
    User
    |> Actions.get(id)
    |> maybe_preload(opts)
  end

  def update_user(id, params, opts \\ []) do
    User
    |> Actions.update(id, params)
    |> case do
      {:error, error} -> {:error, error}
      {:ok, schema_data} -> maybe_preload(schema_data, opts)
    end
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

  def get_users(params \\ %{}, opts \\ []) do
    User
    |> CommonFilters.convert_params_to_filter(params)
    |> Repo.all()
    |> maybe_preload(opts)
  end

  defp maybe_preload(schema_data, opts) do
    case opts[:preload] do
      nil -> schema_data
      preload -> Repo.preload(schema_data, preload)
    end
  end
end
