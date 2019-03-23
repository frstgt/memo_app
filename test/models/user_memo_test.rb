require 'test_helper'

class UserMemoTest < ActiveSupport::TestCase

  def setup
    @note = user_notes(:user1_note1)
    @memo = @note.user_memos.build(content: "Test Memo", number: '1')
  end

  test "should be valid" do
    assert @memo.valid?
  end

  test "user_note id should be present" do
    @memo.user_note_id = nil
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
    assert_equal user_memos(:user1_memo_top_number), UserMemo.first
  end

end
