require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "welcome" do
    user = users(:neo)
    user.activation_token = User.new_token
    program = programs(:one)
    mail = UserMailer.welcome(user, program)
    assert_equal "Welcome to the program", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@entrainhq.com"], mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded

    user = users(:stew)
    mail = UserMailer.welcome(user, program)
    assert_equal "Welcome to the program", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@entrainhq.com"], mail.from
    assert_match user.name,                 mail.body.encoded
    assert_match "programs/#{program.id}",  mail.body.encoded
    assert_no_match user.activation_token,  mail.body.encoded
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
