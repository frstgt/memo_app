require 'test_helper'

class UserNoteTest < ActiveSupport::TestCase

  def setup
    @user = users(:user1)
    @user_pname = pen_names(:user1_pen_name1)
    @note = @user.user_notes.build(title: "Lorem ipsum",
                                   outline: "This is test.", pen_name_id: @user_pname.id)
  end

  test "should be valid" do
    assert @note.valid?
  end

  test "user id should be present" do
    @note.user_id = nil
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
    assert_equal user_notes(:user1_note_most_recent), UserNote.first
  end

end
