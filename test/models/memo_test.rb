require 'test_helper'

class MemoTest < ActiveSupport::TestCase

  def setup
    @note = notes(:orange)
    @memo = @note.memos.build(content: "Test Memo", number: '1')
  end

  test "should be valid" do
    assert @memo.valid?
  end

  test "note id should be present" do
    @memo.note_id = nil
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
    assert_equal memos(:thr), Memo.first
  end

end
