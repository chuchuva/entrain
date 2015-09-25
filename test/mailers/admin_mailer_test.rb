require 'test_helper'

class AdminMailerTest < ActionMailer::TestCase
  test "new_order" do
    order = orders(:one)
    mail = AdminMailer.new_order(order)
    assert_equal "New order from John Smith", mail.subject
    assert_equal ["charlie@example.com"], mail.to
    assert_equal ["server@entrainhq.com"], mail.from
    assert_match order.first_name, mail.body.encoded
    assert_match order.last_name, mail.body.encoded
    assert_match order.email, mail.body.encoded
    assert_match "\$9.99", mail.body.encoded
  end

end
