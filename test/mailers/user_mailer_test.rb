require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "welcome" do
    mail = UserMailer.welcome
    assert_equal "Welcome", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["noreply@entrainhq.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "password_reset" do
    user = users(:charlie)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Password reset", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@entrainhq.com"], mail.from
    assert_match user.reset_token,        mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end

end
