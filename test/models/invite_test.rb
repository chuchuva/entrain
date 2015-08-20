require 'test_helper'

class InviteTest < ActiveSupport::TestCase
  test "invite_by_email should create a record with key" do
    invite = Invite.invite_by_email 'john@example.com', users(:charlie)
    assert_not_nil invite
    assert_not invite.invite_key.empty?
  end
end
