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
      assert ResolverBucket.get_key_count(:create_user, pid) === 0
      ResolverBucket.increment_key(:create_user, pid)
      assert ResolverBucket.get_key_count(:create_user, pid) === 1
    end

    test "increments update_user count", %{pid: pid} do
      assert ResolverBucket.get_key_count(:update_user, pid) === 0
      ResolverBucket.increment_key(:update_user, pid)
      assert ResolverBucket.get_key_count(:update_user, pid) === 1
    end

    test "increments update_user_preferences count", %{pid: pid} do
      assert ResolverBucket.get_key_count(:update_user_preferences, pid) === 0
      ResolverBucket.increment_key(:update_user_preferences, pid)
      assert ResolverBucket.get_key_count(:update_user_preferences, pid) === 1
    end

    test "increments get_user count", %{pid: pid} do
      assert ResolverBucket.get_key_count(:get_user, pid) === 0
      ResolverBucket.increment_key(:get_user, pid)
      assert ResolverBucket.get_key_count(:get_user, pid) === 1
    end

    test "increments get_users count", %{pid: pid} do
      assert ResolverBucket.get_key_count(:get_users, pid) === 0
      ResolverBucket.increment_key(:get_users, pid)
      assert ResolverBucket.get_key_count(:get_users, pid) === 1
    end
  end
end
