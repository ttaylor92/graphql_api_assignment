defmodule GraphqlApiAssignment.ResolverBucketTest do
  use ExUnit.Case, async: true

  alias GraphqlApiAssignment.ResolverBucket

  describe "incrementing user action counts" do
    test "increments create_user count" do
      {:ok, pid} = ResolverBucket.start_link(name: :create_user_bucket, table_name: :create_user_table)

      assert ResolverBucket.get_key_count(:create_user, pid) === 0
      ResolverBucket.increment_key(:create_user, pid)
      assert ResolverBucket.get_key_count(:create_user, pid) === 1
    end

    test "increments update_user count" do
      {:ok, pid} = ResolverBucket.start_link(name: :update_user_bucket, table_name: :update_user_table)

      assert ResolverBucket.get_key_count(:update_user, pid) === 0
      ResolverBucket.increment_key(:update_user, pid)
      assert ResolverBucket.get_key_count(:update_user, pid) === 1
    end

    test "increments update_user_preferences count" do
      {:ok, pid} = ResolverBucket.start_link(name: :update_user_preferences_bucket, table_name: :update_user_preferences_table)

      assert ResolverBucket.get_key_count(:update_user_preferences, pid) === 0
      ResolverBucket.increment_key(:update_user_preferences, pid)
      assert ResolverBucket.get_key_count(:update_user_preferences, pid) === 1
    end

    test "increments get_user count" do
      {:ok, pid} = ResolverBucket.start_link(name: :get_user_bucket, table_name: :get_user_table)

      assert ResolverBucket.get_key_count(:get_user, pid) === 0
      ResolverBucket.increment_key(:get_user, pid)
      assert ResolverBucket.get_key_count(:get_user, pid) === 1
    end

    test "increments get_users count" do
      {:ok, pid} = ResolverBucket.start_link(name: :get_users_bucket, table_name: :get_users_table)

      assert ResolverBucket.get_key_count(:get_users, pid) === 0
      ResolverBucket.increment_key(:get_users, pid)
      assert ResolverBucket.get_key_count(:get_users, pid) === 1
    end
  end
end
