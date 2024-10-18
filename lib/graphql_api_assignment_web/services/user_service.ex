defmodule GraphqlApiAssignmentWeb.Services.UserService do
  @users [%{
    id: 1,
    name: "Bill",
    email: "bill@gmail.com",
    preferences: %{
      likes_emails: false,
      likes_phone_calls: true,
      likes_faxes: true
    }
  }, %{
    id: 2,
    name: "Alice",
    email: "alice@gmail.com",
    preferences: %{
      likes_emails: true,
      likes_phone_calls: false,
      likes_faxes: true
    }
  }, %{
    id: 3,
    name: "Jill",
    email: "jill@hotmail.com",
    preferences: %{
      likes_emails: true,
      likes_phone_calls: true,
      likes_faxes: false
    }
  }, %{
    id: 4,
    name: "Tim",
    email: "tim@gmail.com",
    preferences: %{
      likes_emails: false,
      likes_phone_calls: false,
      likes_faxes: false
    }
  }]

  def get_user_by_id(id) do
    user = Enum.find(@users, false, fn user -> user.id === id end)

    if user !== false do
      {:ok, user}
    else
      {:error, message: "User not found"}
    end
  end

  def create_user(args) do
    {:ok, args}
  end

  def get_users_by_preferences(args) do
    filtered_users = Enum.filter(@users, fn user ->
      Enum.all?(Map.keys(args), fn key ->
        args[key] === nil or user.preferences[key] === args[key]
      end)
    end)
    {:ok, filtered_users}
  end

  def update_a_user(args) do
    case get_user_by_id(args.user_id) do
      {:ok, user} ->
        updated_user = Map.merge(user, args)
        {:ok, updated_user}

      {:error, reason} -> {:error, reason}
    end
  end

  def update_user_preference(args) do
    case get_user_by_id(args.id) do
      {:ok, user} ->
        updated_preferences = Map.merge(user.preferences, Map.take(args, [:likes_emails, :likes_phone_calls, :likes_faxes]))
        updated_user = Map.put(user, :preferences, updated_preferences)
        {:ok, updated_user}

      {:error, reason} -> {:error, reason}
    end
  end
end
