require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name:  "",
                               email: "user@invalid" }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end
  
  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, user: { name:  "Example User",
                               email: "user@example.com" }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.password_set?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token")
    assert_redirected_to login_url
    follow_redirect!
    assert_not flash.empty?
    assert_template 'session/new'
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_redirected_to login_url
    follow_redirect!
    assert_not flash.empty?
    assert_template 'session/new'
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert flash.empty?
    assert_template 'account_activations/edit'
    # Invalid password & confirmation
    patch account_activation_path(user.activation_token),
          email: user.email,
          user: { password:              "foobaz",
                  password_confirmation: "barquux" }
    assert_select 'div#error_explanation'
    # Empty password
    patch account_activation_path(user.activation_token),
          email: user.email,
          user: { password:              "",
                  password_confirmation: "" }
    assert_select 'div#error_explanation'
    # Valid password & confirmation
    patch account_activation_path(user.activation_token),
          email: user.email,
          user: { password:              "foobaz",
                  password_confirmation: "foobaz" }
    assert user.reload.password_set?
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to root_url
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
    assert_equal 1, ActionMailer::Base.deliveries.size
  end
end
