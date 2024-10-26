defmodule GraphqlApiAssignmentWeb.Schema.Queries.UserQueriesTest do
  use GraphqlApiAssignment.Support.Datacase

  import Support.HelperFunctions, only: [setup_mock_accounts: 1]

  alias GraphqlApiAssignmentWeb.Schema

  alias GraphqlApiAssignment.Support.Factory.Pg.AccountManagement.{
    PreferenceFactory,
    UserFactory
  }

  describe "@user" do
    setup [:setup_mock_accounts]

    @query_user """
      query($id: Int!) {
        user(id: $id) {
          id
          name
          email
          preferences {
            likesEmails
            likesPhoneCalls
            likesFaxes
            userId
          }
        }
      }
    """
    test "fetches a user by ID", context do
      variables = %{"id" => context.user.id}

      assert {:ok, %{data: %{"user" => user}}} =
               Absinthe.run(@query_user, Schema, variables: variables)

      assert user["id"] == context.user.id
      assert user["name"] == context.user.name
      assert user["email"] == context.user.email
      assert user["preferences"]["likesEmails"] == context.preference.likes_emails
      assert user["preferences"]["likesFaxes"] == context.preference.likes_faxes
      assert user["preferences"]["likesPhoneCalls"] == context.preference.likes_phone_calls
      assert user["preferences"]["userId"] == context.preference.user_id
    end

    test "returns an error when ID does not exist" do
      variables = %{"id" => -1}

      assert {:ok, %{data: %{"user" => user}}} =
               Absinthe.run(@query_user, Schema, variables: variables)

      assert user == nil
    end
  end

  describe "@users" do
    setup [:setup_mock_accounts]

    @query_users """
      query ($first: Int, $after: Int, $before: Int) {
        users(first: $first, after: $after, before: $before) {
          id
          name
          email
          preferences {
            likesEmails
            likesPhoneCalls
            likesFaxes
            userId
          }
        }
      }
    """

    test "fetches users with no arguments", context do
      variables = %{}

      assert {:ok, %{data: %{"users" => users}}} =
               Absinthe.run(@query_users, Schema, variables: variables)

      assert length(users) > 0
      assert Enum.any?(users, fn user -> user["id"] == context.user.id end)
    end

    test "fetches users with preferences", context do
      variables = %{"first" => 1}

      assert {:ok, %{data: %{"users" => users}}} =
               Absinthe.run(@query_users, Schema, variables: variables)

      assert length(users) == 1
      assert Enum.any?(users, fn user -> user["id"] == context.user.id end)
    end

    test "fetches users before a given ID", context do
      additional_user = UserFactory.insert!()
      _additional_preference = PreferenceFactory.insert!(%{user_id: additional_user.id})

      variables = %{"before" => additional_user.id}

      assert {:ok, %{data: %{"users" => users}}} =
               Absinthe.run(@query_users, Schema, variables: variables)

      assert length(users) > 0
      assert Enum.any?(users, fn user -> user["id"] == context.user.id end)
    end

    test "fetches users after a given ID", context do
      additional_user = UserFactory.insert!()
      _additional_preference = PreferenceFactory.insert!(%{user_id: additional_user.id})

      variables = %{"after" => context.user.id}

      assert {:ok, %{data: %{"users" => users}}} =
               Absinthe.run(@query_users, Schema, variables: variables)

      assert length(users) > 0
      assert Enum.any?(users, fn user -> user["id"] == additional_user.id end)
    end

    test "fetches users with multiple parameters", context do
      1..6
      |> Enum.each(fn _ ->
        user = UserFactory.insert!()
        PreferenceFactory.insert!(%{user_id: user.id})
      end)

      variables = %{"after" => context.user.id, "before" => context.user.id + 6, "first" => 3}

      assert {:ok, %{data: %{"users" => users}}} =
               Absinthe.run(@query_users, Schema, variables: variables)

      assert length(users) > 0
      filtered_list = Enum.filter(users, fn user -> user["id"] < context.user.id + 6 end)
      assert length(filtered_list) == 3
    end
  end
end
