require 'test_helper'

class InviteRedeemerTest < ActiveSupport::TestCase
  test "redeem should create a user" do
    invite = invites(:valid)
    user = InviteRedeemer.new(invite, "password").redeem
    assert_not_nil user
    assert_equal invite.email, user.email
  end
end
