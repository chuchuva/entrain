require 'test_helper'

class ProgramTest < ActiveSupport::TestCase
  test "adding user to program should grant access" do
    program = programs(:two)
    user = users(:stew)
    assert_not user.has_access?(program)
    program.add_user(user)
    assert user.has_access?(program)
    assert program.users.include?(user)
   end

  test "removing user from program should revoke access" do
    program = programs(:one)
    user = users(:stew)
    assert user.has_access?(program)
    program.remove_user(user)
    assert_not user.has_access?(program)
    assert_not program.users.include?(user)
   end
end
