require 'test_helper'

class InvitesControllerTest < ActionController::TestCase
  setup do
    @invite = invites(:valid)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:invites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create invite" do
    log_in_as(users(:charlie))
    assert is_logged_in?, 'User is not logged in'
    get :new
    assert_difference('Invite.count') do
      post :create, invite: { email: "test4@example.com" }
    end

    assert_redirected_to action: 'show_admin', id: assigns(:invite).id
  end

  test "should return error if user already exists" do
    log_in_as(users(:charlie))
    assert is_logged_in?, 'User is not logged in'
    get :new
    assert_no_difference('Invite.count') do
      post :create, invite: { email: "charlie@example.com" }
    end
    assert_template 'invites/new'
  end

  test "should show invite" do
    get :show, id: @invite.invite_key
    assert_response :success
  end

  test "should destroy invite" do
    assert_difference('Invite.count', -1) do
      delete :destroy, id: @invite
    end

    assert_redirected_to invites_path
  end
end
