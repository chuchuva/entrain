require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
  end
  
  test "sign up should create user" do
    get signup_path
    assert_template 'users/new'
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name:  "Example User",
                                            email: "user@example.com",
                                            password:              "password" }
    end
    assert is_logged_in?, 'User is not logged in'
  end

end
