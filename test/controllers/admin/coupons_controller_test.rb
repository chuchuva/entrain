require 'test_helper'

class Admin::CouponsControllerTest < ActionController::TestCase
  setup do
    @program = programs(:one)
    @coupon = coupons(:one)
    log_in_as(users(:charlie))
  end

  test "should get index" do
    get :index, program_id: @program.id
    assert_response :success
    assert_not_nil assigns(:coupons)
  end

  test "should get new" do
    get :new, program_id: @program.id
    assert_response :success
  end

  test "should create coupon" do
    assert_difference('Coupon.count') do
      post :create, program_id: @program.id, coupon: {
        code: 'XYZ', price: @coupon.price }
    end

    assert_redirected_to admin_coupon_path(assigns(:coupon))
  end

  test "should show coupon" do
    get :show, id: @coupon
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @coupon
    assert_response :success
  end

  test "should update coupon" do
    patch :update, id: @coupon, program_id: @program, coupon: {
      code: @coupon.code, price: @coupon.price }
    assert_redirected_to admin_coupon_path(assigns(:coupon))
  end

  test "should destroy coupon" do
    assert_difference('Coupon.count', -1) do
      delete :destroy, id: @coupon
    end

    assert_redirected_to admin_program_coupons_path(@program)
  end
end
