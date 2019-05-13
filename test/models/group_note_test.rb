require 'test_helper'

class GroupNoteTest < ActiveSupport::TestCase

  def setup
    @group = groups(:group1)
    @note = @group.group_notes.build(title: "Test note", outline: "This is a test.")
  end

  test "should be valid" do
    assert @note.valid?
  end

  test "group id should be present" do
    @note.group_id = nil
    assert_not @note.valid?
  end

  test "title should be present" do
    @note.title = "   "
    assert_not @note.valid?
  end

  test "title should be at most 100 characters" do
    @note.title = "a" * 101
    assert_not @note.valid?
  end

  test "description should be at most 1000 characters" do
    @note.outline = "a" * 1001
    assert_not @note.valid?
  end

  test "order should be most recent first" do
    assert_equal group_notes(:group1_note_most_recent), GroupNote.first
  end

end
