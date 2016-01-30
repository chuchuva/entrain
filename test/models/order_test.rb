require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test "create order" do
    site = sites(:site1)
    program = site.programs.first
    order = site.orders.build({
      first_name: 'John',
      last_name: 'New',
      email: 'john@example.com',
      pay_method: :card})
    order.program = program
    assert_nil order.id
    assert_difference 'User.count', 1 do
      order.submit!
    end
    assert_not_nil order.id
    assert_not_nil order.user
    assert_equal 'john@example.com', order.user.email
    assert order.user.has_access?(program)
  end

  test "creating order with bank transfer should not create user" do
    site = sites(:site1)
    program = site.programs.first
    order = site.orders.build({
      first_name: 'John',
      last_name: 'New',
      email: 'john@example.com',
      pay_method: :bank_transfer})
    order.program = program
    assert_nil order.id
    assert_no_difference 'User.count' do
      order.submit!
    end
    assert_not_nil order.id
    assert_nil order.user
  end  
end
