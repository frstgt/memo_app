require 'test_helper'

class MemoTest < ActiveSupport::TestCase

  def setup
    @note = user_notes(:user1_note1)
    @memo = @note.memos.build(content: "Test Memo", number: '1')
  end

  test "should be valid" do
    assert @memo.valid?
  end

  test "memo id should be present" do
    @memo.note_id = nil
    assert_not @memo.valid?
  end

  test "content should be at most 1000 characters" do
    @memo.content = "a" * 1001
    assert_not @memo.valid?
  end

  test "order should be least number first" do
    assert_equal memos(:user1_memo_top_number), Memo.first
  end

end
