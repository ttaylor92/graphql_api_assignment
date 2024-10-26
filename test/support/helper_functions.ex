defmodule Support.HelperFunctions do
  alias GraphqlApiAssignment.Support.Factory.Pg.AccountManagement.{
    PreferenceFactory,
    UserFactory
  }

  def setup_mock_accounts(context) do
    user = UserFactory.insert!()
    preference = PreferenceFactory.insert!(%{user_id: user.id})

    Map.merge(context, %{
      user: user,
      preference: preference
    })
  end
end
