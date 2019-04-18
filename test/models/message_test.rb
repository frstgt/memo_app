require 'test_helper'

class MessageTest < ActiveSupport::TestCase

  def setup
    @group = groups(:group1)
    @pen_name = pen_names(:user1_pen_name1)
    @message = @group.messages.build(content: "Test Message", pen_name_id: @pen_name.id)
  end

  test "should be valid" do
    assert @message.valid?
  end

  test "group id should be present" do
    @message.group_id = nil
    assert_not @message.valid?
  end

  test "pen_name id should be present" do
    @message.pen_name_id = nil
    assert_not @message.valid?
  end

  test "content should be present" do
    @message.content = "    "
    assert_not @message.valid?
  end

  test "content should be at most 200 characters" do
    @message.content = "a" * 201
    assert_not @message.valid?
  end

  test "order should be least number first" do
    assert_equal messages(:group1_last_message), Message.first
  end

end
