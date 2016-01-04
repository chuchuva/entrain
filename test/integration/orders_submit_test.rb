require 'test_helper'

class OrdersSubmitTest < ActionDispatch::IntegrationTest
  def setup
  end

  test "submit order with bank transfer" do
    assert_not sites(:site1).setting(:bank_transfer_enabled)
    program = programs(:one)
    get new_order_path(program)
    assert_template 'orders/new'
    assert_select "input#order_pay_method_bank_transfer", false

    assert sites(:anothersite).setting(:bank_transfer_enabled)
    host! "anothersite.test.host"
    program = programs(:program_for_another_site)
    get new_order_path(program)
    assert_template 'orders/new'
    assert_select "input#order_pay_method_bank_transfer"
    assert_no_difference 'User.count' do
      assert_difference 'Order.count', 1 do
        post_via_redirect orders_path(program), order: {
          first_name: "John",
          last_name: "Smith",
          email: "john@example.com",
          pay_method: :bank_transfer }
      end
    end
    assert_template 'orders/bank_transfer_instructions'
  end
end
