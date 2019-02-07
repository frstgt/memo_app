require 'test_helper'

class NoteTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @note = @user.notes.build(title: "Lorem ipsum",
                              description: "This is test.")
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
    @note.description = "a" * 1001
    assert_not @note.valid?
  end

  test "order should be most recent first" do
    assert_equal notes(:most_recent), Note.first
  end

end
