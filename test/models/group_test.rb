require 'test_helper'

class GroupTest < ActiveSupport::TestCase

  def setup
    @group = groups(:group1)
  end

  test "should be valid" do
    assert @group.valid?
  end

  test "name should be present" do
    @group.name = "   "
    assert_not @group.valid?
  end

  test "name should not be too short" do
    @group.name = "a" * 7
    assert_not @group.valid?
  end

  test "name should not be too long" do
    @group.name = "a" * 33
    assert_not @group.valid?
  end

  test "description should be at most 1000 characters" do
    @group.outline = "a" * 1001
    assert_not @group.valid?
  end

  test "status should be present" do
    @group.status = nil
    assert_not @group.valid?
  end

end
