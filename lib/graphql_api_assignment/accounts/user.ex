defmodule GraphqlApiAssignment.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    has_one :preferences, GraphqlApiAssignment.Accounts.Preference,  on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @required_fields [:name, :email]
  @available_fields []

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @available_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &String.downcase(&1))
    |> unique_constraint(:email)
    |> cast_assoc(:preferences)
  end

end
