ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Returns true if a test user is logged in.
  def is_logged_in?
    cookie = cookies['_t']
    !cookie.nil? && cookie.length == 32
  end

  # Logs in a test user.
  def log_in_as(user, options = {})
    password = options[:password]    || 'password'
    if integration_test?
      post login_path, session: { email:       user.email,
                                  password:    password }
    else
      cookies['_t'] = user.auth_token
    end
  end

  private

    # Returns true inside an integration test.
    def integration_test?
      defined?(post_via_redirect)
    end
end
