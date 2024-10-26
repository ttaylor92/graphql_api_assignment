defmodule GraphqlApiAssignmentWeb.Schema.Mutations.UserMutationTest do
  use GraphqlApiAssignment.Support.Datacase

  import Support.HelperFunctions, only: [setup_mock_accounts: 1]

  alias GraphqlApiAssignmentWeb.Schema


  @create_user_query """
  mutation($name: String!, $email: String!, $preferences: PreferenceInput!) {
    createUser(name: $name, email: $email, preferences: $preferences) {
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
  describe "@createUser" do
    test "creates a user successfully" do
      variables = %{
        "name" => "John Doe",
        "email" => "john@example.com",
        "preferences" => %{
          "likesEmails" => true,
          "likesFaxes" => false,
          "likesPhoneCalls" => true
        }
      }

      assert {:ok, %{data: %{"createUser" => user}}} =
               Absinthe.run(@create_user_query, Schema, variables: variables)

      assert user["name"] == "John Doe"
      assert user["email"] == "john@example.com"
      assert user["preferences"]["likesEmails"] == true
      assert user["preferences"]["likesFaxes"] == false
      assert user["preferences"]["likesPhoneCalls"] == true
    end

    test "does not create a user with invalid email format" do
      variables = %{
        "name" => "John Doe",
        "email" => "invalid_email",
        "preferences" => %{
          "likesEmails" => true,
          "likesFaxes" => false,
          "likesPhoneCalls" => true
        }
      }

      assert {:ok, %{errors: errors}} =
               Absinthe.run(@create_user_query, Schema, variables: variables)
      error = List.first(errors)
      assert error.message == "There was an error creating the user"
      assert "has invalid format" in error.errors.email
    end
  end

  @update_user_query """
  mutation($id: Int!, $name: String, $email: String) {
    updateUser(id: $id, name: $name, email: $email) {
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
  describe "@updateUser" do
    setup [:setup_mock_accounts]

    test "updates a user successfully", context do

      variables = %{"id" => context.user.id, "name" => "Jane Doe", "email" => "jane@example.com"}

      assert {:ok, %{data: %{"updateUser" => updated_user}}} =
               Absinthe.run(@update_user_query, Schema, variables: variables)

      assert updated_user["name"] == variables["name"]
      assert updated_user["email"] == variables["email"]
    end


    test "updates a user's name successfully", context do
      variables = %{"id" => context.user.id, "name" => "Updated Name"}

      assert {:ok, %{data: %{"updateUser" => updated_user}}} =
               Absinthe.run(@update_user_query, Schema, variables: variables)

      assert updated_user["name"] == variables["name"]
      assert updated_user["email"] == context.user.email
    end

    test "updates a user's email successfully", context do
      variables = %{"id" => context.user.id, "email" => "updated_email@example.com"}

      assert {:ok, %{data: %{"updateUser" => updated_user}}} =
               Absinthe.run(@update_user_query, Schema, variables: variables)

      assert updated_user["email"] == variables["email"]
      assert updated_user["name"] == context.user.name
    end

    test "cannot update a user with non-existent ID" do
      user_id = 999
      message = "No item found with id: #{user_id}"
      variables = %{"id" => user_id, "name" => "Jane Doe", "email" => "jane@example.com"}

      assert {:ok, %{errors: errors}} =
               Absinthe.run(@update_user_query, Schema, variables: variables)

      assert List.first(errors).message == message
    end
  end

  @update_user_preferences_query """
  mutation($userId: Int!, $likesEmails: Boolean, $likesFaxes: Boolean, $likesPhoneCalls: Boolean) {
    updateUserPreferences(userId: $userId, likesEmails: $likesEmails, likesFaxes: $likesFaxes, likesPhoneCalls: $likesPhoneCalls) {
      likesEmails
      likesFaxes
      likesPhoneCalls
      userId
    }
  }
  """
  describe "@updateUserPreferences" do
    setup [:setup_mock_accounts]

    test "updates all user preferences successfully", context do
      variables = %{
        "userId" => context.user.id,
        "likesEmails" => true,
        "likesFaxes" => true,
        "likesPhoneCalls" => true
      }

      assert {:ok, %{data: %{"updateUserPreferences" => preferences}}} =
               Absinthe.run(@update_user_preferences_query, Schema, variables: variables)

      assert preferences["likesEmails"] == true
      assert preferences["likesFaxes"] == true
      assert preferences["likesPhoneCalls"] == true
    end

    test "updates user preference for likesEmails successfully", context do
      variables = %{
        "userId" => context.user.id,
        "likesEmails" => true
      }

      assert {:ok, %{data: %{"updateUserPreferences" => preferences}}} =
               Absinthe.run(@update_user_preferences_query, Schema, variables: variables)

      assert preferences["likesEmails"] == true
    end

    test "updates user preference for likesFaxes successfully", context do
      variables = %{
        "userId" => context.user.id,
        "likesFaxes" => true
      }

      assert {:ok, %{data: %{"updateUserPreferences" => preferences}}} =
               Absinthe.run(@update_user_preferences_query, Schema, variables: variables)

      assert preferences["likesFaxes"] == true
    end

    test "updates user preference for likesPhoneCalls successfully", context do
      variables = %{
        "userId" => context.user.id,
        "likesPhoneCalls" => true
      }

      assert {:ok, %{data: %{"updateUserPreferences" => preferences}}} =
               Absinthe.run(@update_user_preferences_query, Schema, variables: variables)

      assert preferences["likesPhoneCalls"] == true
    end

    test "updates user preferences with non-existent user ID" do
      variables = %{
        "userId" => 99999,
        "likesEmails" => false,
        "likesFaxes" => true,
        "likesPhoneCalls" => false
      }

      assert {:ok, %{errors: errors}} =
               Absinthe.run(@update_user_preferences_query, Schema, variables: variables)
      assert List.first(errors).message ==  "User not found"
    end
  end
end
