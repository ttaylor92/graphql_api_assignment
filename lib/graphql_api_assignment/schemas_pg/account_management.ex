defmodule GraphqlApiAssignment.SchemasPG.AccountManagement do
  @moduledoc """
  The Accounts context.

  This context is responsible for managing user accounts, including creation,
  retrieval, updating, and deletion of user data.
  """
  import Ecto.Query, only: [from: 2]

  alias EctoShorts.Actions
  alias GraphqlApiAssignment.SchemasPG.AccountManagement.{User, Preference}
  alias GraphqlApiAssignment.Repo

  # def data do
  #   Dataloader.Ecto.new(GraphqlApiAssignment.Repo, query: &query/2)
  # end

  # def query(queryable, _params) do
  #   queryable
  # end

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

  def get_users(params \\ %{}) do
    where = params
      |> Map.get(:preferences, %{})
      |> Map.to_list()

    options = params
      |> Map.delete(:preferences)
      |> Map.keys()
      |> Enum.map(fn key -> {key, Map.get(params, key)} end)

    from(p in Preference, join: u in User, on: p.user_id == u.id, where: ^where,  select: %{u | preferences: p})
    |> Actions.all(options)
  end

  defp maybe_preload(schema_data, opts) do
    case opts[:preload] do
      nil -> schema_data
      preload -> Repo.preload(schema_data, preload)
    end
  end
end
