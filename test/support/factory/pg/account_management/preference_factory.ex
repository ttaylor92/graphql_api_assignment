defmodule GraphqlApiAssignment.Support.Factory.Pg.AccountManagement.PreferenceFactory do
  @behaviour FactoryEx

  @schema GraphqlApiAssignment.Pg.AccountManagement.Preference
  @repo GraphqlApiAssignment.Repo

  def schema, do: @schema

  def repo, do: @repo

  def build(params \\ %{}) do
    default = %{
      likes_emails: false,
      likes_phone_calls: false,
      likes_faxes: false
    }

    Map.merge(default, params)
  end

  def insert!(attrs \\ %{}) do
    attrs
    |> build()
    |> @schema.create_changeset()
    |> @repo.insert!()
  end
end
