require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test "create order" do
    site = sites(:site1)
    program = site.programs.first
    order = site.orders.build({
      first_name: 'John',
      last_name: 'New',
      email: 'john@example.com'})
    order.program = program
    assert_nil order.id
    assert_difference 'User.count', 1 do
      order.submit!
    end
    assert_not_nil order.id
    assert_equal 'john@example.com', order.user.email
  end
end
