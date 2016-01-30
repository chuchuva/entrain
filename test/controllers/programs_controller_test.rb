require 'test_helper'

class ProgramsControllerTest < ActionController::TestCase
  test "should get index" do
    log_in_as(users(:stew))
    get :index
    assert_redirected_to programs(:one)
  end

end
