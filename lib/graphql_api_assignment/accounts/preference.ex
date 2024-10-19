defmodule GraphqlApiAssignment.Accounts.Preference do
  use Ecto.Schema
  import Ecto.Changeset

  schema "preferences" do
    field :likes_emails, :boolean, default: false
    field :likes_phone_calls, :boolean, default: false
    field :likes_faxes, :boolean, default: false
    belongs_to :user, GraphqlApiAssignment.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @required_fields []
  @available_fields [:likes_emails, :likes_phone_calls, :likes_faxes]

  @doc false
  def changeset(preference, attrs) do
    preference
    |> cast(attrs, @available_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end

end
