require 'test_helper'

class MemoInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "memo interface" do
    skip "hold on"

    log_in_as(@user)
    get new_note_path
    assert_template 'notes/new'

    assert_difference 'User.count', 1 do
      post notes_path, params: {note: {title: "Test Note", description: "This is a test."} }
    end
    follow_redirect!
    assert_template 'users/show'

#    @note = @user.notes.find_by(title: "Test Note")
#    p @note

  end
  
end