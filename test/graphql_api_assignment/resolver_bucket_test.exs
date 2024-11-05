defmodule GraphqlApiAssignment.ResolverBucketTest do
  use ExUnit.Case, async: true

  alias GraphqlApiAssignment.ResolverBucket

  describe "incrementing user action counts" do
    setup do
      gen_server_name = nil
      {:ok, pid} = ResolverBucket.start_link(name: gen_server_name)

      %{pid: pid}
    end

    test "increments create_user count", %{pid: pid} do
      assert ResolverBucket.get_create_user_count(pid) === 0
      ResolverBucket.increment_create_user(pid)
      assert ResolverBucket.get_create_user_count(pid) === 1
    end

    test "increments update_user count", %{pid: pid} do
      assert ResolverBucket.get_update_user_count(pid) === 0
      ResolverBucket.increment_update_user(pid)
      assert ResolverBucket.get_update_user_count(pid) === 1
    end

    test "increments update_user_preferences count", %{pid: pid} do
      assert ResolverBucket.get_update_user_preferences_count(pid) === 0
      ResolverBucket.increment_update_user_preferences(pid)
      assert ResolverBucket.get_update_user_preferences_count(pid) === 1
    end

    test "increments get_user count", %{pid: pid} do
      assert ResolverBucket.get_user_count(pid) === 0
      ResolverBucket.increment_get_user(pid)
      assert ResolverBucket.get_user_count(pid) === 1
    end

    test "increments get_users count", %{pid: pid} do
      assert ResolverBucket.get_users_count(pid) === 0
      ResolverBucket.increment_get_users(pid)
      assert ResolverBucket.get_users_count(pid) === 1
    end
  end
end
