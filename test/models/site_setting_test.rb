require 'test_helper'

class SiteSettingTest < ActiveSupport::TestCase
  test "get setting" do
    assert_equal "blue", sites(:site1).setting(:favorite_color)
    assert_equal "green", sites(:anothersite).setting(:favorite_color)
  end
end
