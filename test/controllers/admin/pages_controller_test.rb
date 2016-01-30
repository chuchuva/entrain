require 'test_helper'

class Admin::PagesControllerTest < ActionController::TestCase
  setup do
    @program = programs(:one)
    @page = pages(:module1_1)
    log_in_as(users(:charlie))
  end

  test "should get index" do
    get :index, program_id: @program.id
    assert_response :success
    assert_not_nil assigns(:pages)
  end

  test "should get new" do
    get :new, program_id: @program.id
    assert_response :success
  end

  test "should create page" do
    assert_difference('Page.count') do
      post :create, program_id: @program.id, page: {
        content: @page.content, slug: @page.slug, title: @page.title }
    end

    assert_redirected_to admin_page_path(assigns(:page))
  end

  test "should show page" do
    get :show, program_id: @page.program_id, id: @page
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @page, program_id: @page.program_id
    assert_response :success
  end

  test "should update page" do
    patch :update, id: @page, program_id: @program, page: {
      content: @page.content, slug: @page.slug, title: @page.title }
    assert_redirected_to admin_page_path(assigns(:page))
  end

  test "should destroy page" do
    assert_difference('Page.count', -1) do
      delete :destroy, program_id: @program, id: @page
    end

    assert_redirected_to admin_program_pages_path(@program)
  end
end
