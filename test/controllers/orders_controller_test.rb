require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  test "should get new" do
    get :new, program_id: programs(:one)
    assert_response :success
  end

end