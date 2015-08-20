require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:charlie)
  end
  
  test "login with invalid information" do
    get login_path
    assert_template 'session/new'
    post login_path, email: "", password: ""
    assert_template 'session/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, email: @user.email, password: "password"
    assert is_logged_in?, 'User is not logged in'
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'programs/index'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    delete logout_path
    assert_not is_logged_in?, 'User is still logged in'
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
  end
end
