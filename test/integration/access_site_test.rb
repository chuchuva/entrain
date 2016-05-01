require 'test_helper'

class AccessSiteTest < ActionDispatch::IntegrationTest

  def setup
    @program = programs(:one)
  end

  test "access restrictions" do
    assert_not is_logged_in?
    get program_path(@program)
    assert_redirected_to login_url
    follow_redirect!
    assert_template 'session/new'
    assert_not flash.empty?

    log_in_as(users(:stew))
    assert is_logged_in?, 'User is not logged in'
    get program_path(@program)
    assert_template 'programs/show'

    get page_path(program_slug: 'a', page_slug: 'b', id: pages(:module1_1))
    assert_template 'pages/show'
    assert_select "h1", {count: 0, text: "No Access"}

    get program_module_path(program_slug: 'a', id: program_modules(:one))
    assert_template 'program_modules/show'
    assert_select "h1", {count: 0, text: "No Access"}
    assert_select "h1", "Module 1 from Program 1 Site 1"

    get program_path(programs(:two))
    assert_template 'programs/no_access'
    assert_select "h1", "No Access"

    get program_module_path(program_slug: 'a', id: program_modules(:module_from_program2))
    assert_template 'programs/no_access'
    assert_select "h1", "No Access"

    get page_path(program_slug: 'a', page_slug: 'b', id: pages(:lesson2_1))
    assert_template 'programs/no_access'
    assert_select "h1", "No Access"

    get admin_programs_path
    assert_select "h1", "Access Denied"

    log_in_as(users(:charlie))
    get admin_programs_path
    assert_template 'admin/programs/index'
    assert_select "h1", "Programs"

  end

  test "admin link in header should be visible to admins only" do
    assert_not is_logged_in?
    get login_url
    assert_select "a", {count: 0, text: "Admin"}
    log_in_as(users(:stew))
    get program_path(@program)
    assert_select "a", {count: 0, text: "Admin"}
    log_in_as(users(:charlie))
    get program_path(@program)
    assert_select "a", "Admin"
  end

end
