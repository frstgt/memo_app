require 'test_helper'

class PenNameTest < ActiveSupport::TestCase

  def setup
    @user = users(:user1)
    @pen_name = @user.pen_names.build(name: "Lorem ipsum", outline: "This is test.")
  end

  test "should be valid" do
    assert @pen_name.valid?
  end

  test "user id should be present" do
    @pen_name.user_id = nil
    assert_not @pen_name.valid?
  end

  test "name should be present" do
    @pen_name.name = "   "
    assert_not @pen_name.valid?
  end

  test "name should be at least 8 characters" do
    @pen_name.name = "a" * 7
    assert_not @pen_name.valid?
  end

  test "name should be at most 32 characters" do
    @pen_name.name = "a" * 33
    assert_not @pen_name.valid?
  end

  test "outline should be at most 1000 characters" do
    @pen_name.outline = "a" * 1001
    assert_not @pen_name.valid?
  end

  test "status should be present" do
    @pen_name.status = nil
    assert_not @pen_name.valid?
  end

end
