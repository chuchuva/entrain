require 'test_helper'

class ProgramParticipantTest < ActiveSupport::TestCase

  def setup
    @participant = ProgramParticipant.new(site_id: 1, program_id: 2, user_id: 3)
  end

  test "should be valid" do
    assert @participant.valid?
  end

  test "should require a program_id" do
    @participant.program_id = nil
    assert_not @participant.valid?
  end

  test "should require a user_id" do
    @participant.user_id = nil
    assert_not @participant.valid?
  end
end
