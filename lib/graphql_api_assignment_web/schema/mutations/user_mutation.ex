defmodule GraphqlApiAssignmentWeb.Schema.Mutations.UserMutation do
  use Absinthe.Schema.Notation

  alias GraphqlApiAssignmentWeb.Resolvers.UserResolver

  object :user_mutations do
    @desc "Create a user"
    field :create_user, :user_response do
      arg :id, non_null(:integer)
      arg :name, non_null(:string)
      arg :email, non_null(:string)
      arg :preferences, non_null(:preference_input)
      resolve &UserResolver.create_user/3
    end

    @desc "Update a user"
    field :update_user, :user_response do
      arg :id, non_null(:integer)
      arg :name, :string
      arg :email, :string
      resolve &UserResolver.update_a_user/3
    end

    @desc "Update a user's preferences"
    field :update_user_preferences, :preference_response do
      arg :user_id, non_null(:integer)
      arg :likes_emails, :boolean
      arg :likes_faxes, :boolean
      arg :likes_phone_calls, :boolean
      resolve &UserResolver.update_a_user/3
    end
  end
end
