require 'test_helper'

class ProgramsControllerTest < ActionController::TestCase
  test "should get index" do
    log_in_as(users(:charlie))
    get :index
    assert_response :success
  end

end
