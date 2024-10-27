defmodule GraphqlApiAssignment.UserServiceTest do
  use GraphqlApiAssignment.Support.Datacase

  import Support.HelperFunctions, only: [setup_mock_accounts: 1]

  alias GraphqlApiAssignment.UserService
  alias GraphqlApiAssignment.Support.Factory.Pg.AccountManagement.{
    PreferenceFactory,
    UserFactory
  }
  alias GraphqlApiAssignment.Pg.AccountManagement.{
    Preference,
    User
  }

  describe "&create_user/1" do
    test "returns error when no name is given" do
      assert {:error, response} = UserService.create_user(%{name: "", email: "tester@mail.com"})
      {:errors, error_map} = List.keyfind(response, :errors, 0)
      assert "can't be blank" in error_map.name
    end

    test "returns error when no email is given" do
      assert {:error, response} = UserService.create_user(%{name: "Johnny"})
      {:errors, error_map} = List.keyfind(response, :errors, 0)
      assert "can't be blank" in error_map.email
    end

    test "returns error when no email is invalid" do
      assert {:error, response} =
               UserService.create_user(%{name: "Johnny", email: "sometext.com"})

      {:errors, error_map} = List.keyfind(response, :errors, 0)
      assert "has invalid format" in error_map.email
    end

    test "returns user when successful" do
      attr = %{name: "John Doe", email: "tester@mail.com"}
      name = attr.name
      email = attr.email

      assert {:ok,
              %User{
                name: ^name,
                email: ^email
              }} = UserService.create_user(attr)
    end
  end

  describe "&get_user_by_id/1" do
    setup [:setup_mock_accounts]

    test "returns user when found", context do
      user_id = context.user.id
      assert {:ok, %User{id: ^user_id, preferences: %{}}} = UserService.get_user_by_id(user_id)
    end

    test "returns error when user not found" do
      assert {:error, message: "User not found"} = UserService.get_user_by_id(999)
    end
  end

  describe "&get_users/1" do
    setup [:setup_mock_accounts]

    test "returns filtered users with no arguments", context do
      user_id = context.user.id
      assert {:ok, response} = UserService.get_users(%{})
      found_user = Enum.find(response, fn user -> user.id === user_id end)
      assert found_user.id === user_id
    end

    test "returns x user when given first x amount", context do
      # insert an additional user
      user = UserFactory.insert!()
      _preference = PreferenceFactory.insert!(%{user_id: user.id})

      user_id = context.user.id
      assert {:ok, response} = UserService.get_users(%{first: 1})
      assert length(response) === 1
      found_user = List.first(response)
      assert found_user.id === user_id
    end

    test "returns users before a given id via before param", context do
      additional_user = UserFactory.insert!()
      _additional_preference = PreferenceFactory.insert!(%{user_id: additional_user.id})

      user_id = context.user.id
      assert {:ok, response} = UserService.get_users(%{before: additional_user.id})
      assert length(response) > 0
      found_user = Enum.find(response, fn user -> user.id === user_id end)
      assert found_user.id === user_id
    end

    test "returns users after a given id via after param", context do
      additional_user = UserFactory.insert!()
      _additional_preference = PreferenceFactory.insert!(%{user_id: additional_user.id})

      user_id = additional_user.id
      assert {:ok, response} = UserService.get_users(%{after: context.user.id})
      assert length(response) > 0
      found_user = Enum.find(response, fn user -> user.id === user_id end)
      assert found_user.id === user_id
    end

    test "returns users after all params have been entered", context do
      Enum.each(1..6, fn _ ->
        user = UserFactory.insert!()
        PreferenceFactory.insert!(%{user_id: user.id})
      end)

      user_id = context.user.id

      assert {:ok, response} =
               UserService.get_users(%{after: user_id, before: user_id + 6, first: 3})

      assert length(response) > 0
      filtered_list = Enum.filter(response, fn user -> user.id < user_id + 6 end)
      assert length(filtered_list) === 3
    end
  end

  describe "&update_a_user/1" do
    setup [:setup_mock_accounts]

    test "returns user when name change successful", context do
      user_id = context.user.id
      new_name = "Jane Doe"

      assert {:ok, %User{id: ^user_id, name: ^new_name}} =
               UserService.update_a_user(%{id: user_id, name: new_name})
    end

    test "returns user when email change successful", context do
      user_id = context.user.id
      new_email = "janedoe@mail.com"

      assert {:ok, %User{id: ^user_id, email: ^new_email}} =
               UserService.update_a_user(%{id: user_id, email: new_email})
    end

    test "returns error when user not found" do
      user_id = 999
      message = "No item found with id: #{user_id}"

      assert {:error, response} = UserService.update_a_user(%{id: user_id})
      assert ^message = Keyword.fetch!(response, :message)
    end
  end

  describe "&update_user_preference/1" do
    setup [:setup_mock_accounts]

    test "returns updated preference when successful", context do
      user_id = context.user.id
      preference_id = context.preference.id

      assert {:ok, %Preference{id: ^preference_id, likes_emails: true}} =
               UserService.update_user_preference(%{user_id: user_id, likes_emails: true})
    end

    test "returns updated preferences when all is successful", context do
      user_id = context.user.id
      preference_id = context.preference.id

      assert {:ok,
              %Preference{
                id: ^preference_id,
                likes_emails: true,
                likes_phone_calls: true,
                likes_faxes: true
              }} =
               UserService.update_user_preference(%{
                 user_id: user_id,
                 likes_emails: true,
                 likes_phone_calls: true,
                 likes_faxes: true
               })
    end

    test "returns error when user not found" do
      assert {:error, message: "User not found"} =
               UserService.update_user_preference(%{user_id: 999})
    end
  end
end
