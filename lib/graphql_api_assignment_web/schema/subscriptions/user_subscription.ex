defmodule GraphqlApiAssignmentWeb.Schema.Subscriptions.UserSubscription do
  use Absinthe.Schema.Notation

  object :user_subscriptions do

    @desc "Subscribe to successful user creations"
    field :created_user, :user_response do
      trigger :create_user, topic: fn _ ->
        "new_user"
      end

      config fn _, _ ->
        {:ok, topic: "new_user" }
      end
    end

    @desc "Subscribe to User Preferences updates"
    field :updated_user_preferences, :preference_response do
      arg :user_id, non_null(:integer)

      trigger :update_user_preferences, topic: fn preference_response ->
        preference_response.user_id
      end

      config fn args, _ ->
        {:ok, topic: args.user_id }
      end
    end
  end
end
