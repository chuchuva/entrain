require 'test_helper'

class Admin::InvitesControllerTest < ActionController::TestCase
  setup do
    @program = programs(:one)
    @invite = invites(:valid)
    log_in_as(users(:charlie))
  end

  test "should get index" do
    get :index, program_id: @program.id
    assert_response :success
    assert_not_nil assigns(:invites)
  end

  test "should get new" do
    get :new, program_id: @program.id
    assert_response :success
  end

  test "should create invite" do
    log_in_as(users(:charlie))
    get :new, program_id: @program.id
    assert_difference('Invite.count') do
      post :create, program_id: @program.id, invite: { 
        email: "test4@example.com" }
    end

    assert_redirected_to admin_program_invites_path(@program)
  end

  test "should return error if user already exists" do
    assert is_logged_in?, 'User is not logged in'
    get :new, program_id: @program.id
    assert_no_difference('Invite.count') do
      post :create, program_id: @program.id, invite: {
        email: "stew@example.com" }
    end
    assert_template 'invites/new'
  end

  test "should show invite" do
    get :show, id: @invite.id
    assert_response :success
  end

  test "should destroy invite" do
    assert_difference('Invite.count', -1) do
      delete :destroy, id: @invite
    end

    assert_redirected_to admin_program_invites_path(@program)
  end
end
