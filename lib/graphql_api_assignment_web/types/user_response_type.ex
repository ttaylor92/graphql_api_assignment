defmodule GraphqlApiAssignmentWeb.Types.UserResponseType do
  use Absinthe.Schema.Notation

  object :user_response do
    field :id, :integer
    field :name, :string
    field :email, :string
    field :preferences, :preference_response
  end

  object :preference_response do
    field :user_id, :integer
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
    field :likes_faxes, :boolean
  end
end
