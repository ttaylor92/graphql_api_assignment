defmodule GraphqlApiAssignmentWeb.ResolverBucketTest do
  use ExUnit.Case, async: true

  alias GraphqlApiAssignmentWeb.ResolverBucket

  describe "incrementing user action counts" do
    setup do
      gen_server_name = :test_server_one
      {:ok, _pid} = ResolverBucket.start_link(name: gen_server_name)

      %{gen_server_name: gen_server_name}
    end

    test "increments create_user count", %{gen_server_name: gen_server_name} do
      assert ResolverBucket.get_create_user_count(gen_server_name) === 0
      ResolverBucket.increment_create_user(gen_server_name)
      assert ResolverBucket.get_create_user_count(gen_server_name) === 1
    end

    test "increments update_user count", %{gen_server_name: gen_server_name} do
      assert ResolverBucket.get_update_user_count(gen_server_name) === 0
      ResolverBucket.increment_update_user(gen_server_name)
      assert ResolverBucket.get_update_user_count(gen_server_name) === 1
    end

    test "increments update_user_preferences count", %{gen_server_name: gen_server_name} do
      assert ResolverBucket.get_update_user_preferences_count(gen_server_name) === 0
      ResolverBucket.increment_update_user_preferences(gen_server_name)
      assert ResolverBucket.get_update_user_preferences_count(gen_server_name) === 1
    end

    test "increments get_user count", %{gen_server_name: gen_server_name} do
      assert ResolverBucket.get_user_count(gen_server_name) === 0
      ResolverBucket.increment_get_user(gen_server_name)
      assert ResolverBucket.get_user_count(gen_server_name) === 1
    end

    test "increments get_users count", %{gen_server_name: gen_server_name} do
      assert ResolverBucket.get_users_count(gen_server_name) === 0
      ResolverBucket.increment_get_users(gen_server_name)
      assert ResolverBucket.get_users_count(gen_server_name) === 1
    end
  end
end
