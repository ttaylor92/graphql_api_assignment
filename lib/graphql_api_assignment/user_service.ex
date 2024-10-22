defmodule GraphqlApiAssignment.UserService do
  alias GraphqlApiAssignment.Accounts

  def get_user_by_id(id) do
    case Accounts.get_user(id, preload: :preferences) do
      nil -> {:error, message: "User not found"}
      user -> {:ok, user}
    end
  end

  def create_user(args) do
    case Accounts.create_user(args) do
      {:ok, user} ->
        {:ok, user}

      {:error, changeset} ->
        {:error, message: "There was an error creating the user", errors: errors_on(changeset)}
    end
  end

  def get_users(args) do
    filtered_users = Accounts.get_users(args, preload: :preferences)
    {:ok, filtered_users}
  end

  def update_a_user(args) do
    case Accounts.update_user(args.user_id, args) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, message: "User not found", errors: errors_on(changeset)}
    end
  end

  def update_user_preference(args) do
    case get_user_by_id(args.user_id) do
      {:ok, user} ->
        preference_id = user.preferences.id

        case Accounts.update_user_preference(preference_id, args) do
          {:ok, preference} ->
            {:ok, preference}

          {:error, changeset} ->
            {:error, message: "Error updating user preferences", errors: errors_on(changeset)}
        end

      {:error, message} ->
        {:error, message}
    end
  end

  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        atom_key = String.to_existing_atom(key)
        opts |> Keyword.get(atom_key, key) |> to_string()
      end)
    end)
  end
end
