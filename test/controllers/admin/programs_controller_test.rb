require 'test_helper'

class Admin::ProgramsControllerTest < ActionController::TestCase
  setup do
    @program = programs(:one)
  end
  
  test "should get index" do
    log_in_as(users(:charlie))
    get :index
    assert_response :success
    assert_not_nil assigns(:programs)
  end

  test "should get new" do
    log_in_as(users(:charlie))
    get :new
    assert_response :success
  end

  test "should create program" do
    log_in_as(users(:charlie))
    assert_difference('Program.count') do
      post :create, program: { name: @program.name, content: @program.content,
        slug: @program.slug }
    end

    assert_redirected_to admin_program_path(assigns(:program))
  end

  test "should show program" do
    log_in_as(users(:charlie))
    get :show, id: @program
    assert_response :success
  end

  test "should get edit" do
    log_in_as(users(:charlie))
    get :edit, id: @program
    assert_response :success
  end

  test "should update program" do
    log_in_as(users(:charlie))
    patch :update, id: @program, program: { name: @program.name, slug: @program.slug,
      content: @program.content}
    assert_redirected_to admin_program_path(assigns(:program))
  end

  test "should destroy program" do
    log_in_as(users(:charlie))
    assert_difference('Program.count', -1) do
      delete :destroy, id: @program
    end

    assert_redirected_to admin_programs_path
  end
end
