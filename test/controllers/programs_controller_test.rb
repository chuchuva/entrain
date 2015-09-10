require 'test_helper'

class ProgramsControllerTest < ActionController::TestCase
  test "should get index" do
    log_in_as(users(:charlie))
    get :index
    assert_redirected_to sites(:site1).programs.first
  end

end
