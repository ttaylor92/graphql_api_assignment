defmodule GraphqlApiAssignment.SchemasPG.AccountManagement.Preference do
  use Ecto.Schema
  import Ecto.Changeset

  schema "preferences" do
    field :likes_emails, :boolean, default: false
    field :likes_phone_calls, :boolean, default: false
    field :likes_faxes, :boolean, default: false
    belongs_to :user, GraphqlApiAssignment.SchemasPG.AccountManagement.User

    timestamps(type: :utc_datetime)
  end

  @required_fields []
  @available_fields [:likes_emails, :likes_phone_calls, :likes_faxes, :user_id]

  @doc false
  def changeset(preference, attrs) do
    preference
    |> cast(attrs, @available_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end

  def create_changeset(params \\ %{}) do
    changeset(%__MODULE__{}, params)
  end

  def data() do
    Dataloader.Ecto.new(GraphqlApiAssignment.Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end
end
