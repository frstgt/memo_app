require 'test_helper'

class GroupMemoTest < ActiveSupport::TestCase

  def setup
    @note = group_notes(:group1_note1)
    @memo = @note.group_memos.build(content: "Test Memo", number: '1')
  end

  test "should be valid" do
    assert @memo.valid?
  end

  test "group_note id should be present" do
    @memo.group_note_id = nil
    assert_not @memo.valid?
  end

  test "content should be present" do
    @memo.content = "    "
    assert_not @memo.valid?
  end

  test "content should be at most 1000 characters" do
    @memo.content = "a" * 1001
    assert_not @memo.valid?
  end

  test "order should be least number first" do
    assert_equal group_memos(:group1_memo_top_number), GroupMemo.first
  end

end
