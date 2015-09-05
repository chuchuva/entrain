require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  def setup
    @site = sites(:site1)
    @user = users(:charlie)
  end

  test "find_user_by_email should return correct user" do
    assert_equal @user, @site.find_user_by_email("charlie@example.com")
    assert_equal nil, @site.find_user_by_email("someone-not-registered@example.com")
  end
end
