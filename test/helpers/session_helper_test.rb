require 'test_helper'

class SessionHelperTest < ActionView::TestCase

  def setup
    @user = users(:charlie)
    log_in @user
  end

  test "current_user returns right user" do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when auth token is wrong" do
    @user.update_attribute(:auth_token, 'bbb')
    assert_nil current_user
  end
end
