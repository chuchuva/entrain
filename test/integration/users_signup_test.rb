require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
  end
  
  test "sign up should create user" do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name:     "Example User",
                                            email:    "user@example.com",
                                            password: "password" }
    end
    assert is_logged_in?, 'User is not logged in'
  end

  test "prevent sign up if email already exists" do
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: { name:     "Someone",
                                            email:    "charlie@example.com",
                                            password: "password" }
    end
    assert_template 'users/new'
  end

  test "user should be able to sign up if he has account on another site" do
    host! "anothersite.test.host"
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name:     "Charlie Coach",
                                            email:    "charlie@example.com",
                                            password: "password" }
    end
    assert is_logged_in?, 'User is not logged in'
  end
end
