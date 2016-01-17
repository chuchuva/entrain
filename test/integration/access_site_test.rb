require 'test_helper'

class AccessSiteTest < ActionDispatch::IntegrationTest

  def setup
    @program = programs(:one)
  end

  test "access restrictions" do
    assert_not is_logged_in?
    get program_path(@program)
    assert_redirected_to login_url
    follow_redirect!
    assert_template 'session/new'
    assert_not flash.empty?

    log_in_as(users(:stew))
    assert is_logged_in?, 'User is not logged in'
    get program_path(@program)
    assert_template 'programs/show'

    get admin_programs_path
    assert_select "h1", "Access Denied"

    log_in_as(users(:charlie))
    get admin_programs_path
    assert_template 'admin/programs/index'
    assert_select "h1", "Listing programs"
  end
end
