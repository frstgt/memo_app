require 'test_helper'

class UserNotesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user1)
    @note = user_notes(:user1_note1)

    @other_user = users(:user2)
  end
  
  test "show note" do
    log_in_as(@other_user)
    get user_note_path(@note)
    assert_redirected_to root_path

    log_in_as(@user)
    get user_note_path(@note)
    assert_template 'user_notes/show'
  end
  
  test "new/create note" do
    log_in_as(@user)
    get new_user_note_path
    assert_template 'user_notes/new'

    assert_difference '@user.user_notes.count', 1 do
      post user_notes_path, params: { user_note: {title: "Test Note", description: "This is a test."} }
    end
    assert_redirected_to @user
  end

  test "edit/update note" do
    log_in_as(@other_user)
    get edit_user_note_path(@note)
    assert_redirected_to root_path

    patch user_note_path(@note), params: { user_note: { title: @note.title, description: "This is a edit test as a wrong user." } }
    assert_redirected_to root_path

    log_in_as(@user)
    get edit_user_note_path(@note)
    assert_template 'user_notes/edit'

    patch user_note_path(@note), params: { user_note: { title: @note.title, description: "This is a edit test." } }
    assert_redirected_to @note
  end

  test "delete note" do
    log_in_as(@other_user)
    assert_difference '@user.user_notes.count', 0 do
      delete user_note_path(@note)
    end
    assert_redirected_to root_path

    log_in_as(@user)
    assert_difference '@user.user_notes.count', -1 do
      delete user_note_path(@note)
    end
    assert_redirected_to @user
  end

  test "to_open/to_close" do
    log_in_as(@other_user)
    get to_close_user_note_path(@note)
    assert_redirected_to root_path
    get to_open_user_note_path(@note)
    assert_redirected_to root_path

    skip "here"

    log_in_as(@user)
    get to_close_user_note_path(@note)
    assert_redirected_to @note
    get to_open_user_note_path(@note)
    assert_redirected_to user_note_path(@note)

#    skip "here"

    log_in_as(@other_user)
    get user_note_path(@note)
    assert_redirected_to user_note_path(@note)

    log_in_as(@user)
    get user_note_path(@note)
    assert_redirected_to user_note_path(@note)

    log_in_as(@user)
    get to_close_user_note_path(@note)
    assert_redirected_to user_note_path(@note)

    log_in_as(@other_user)
    get user_note_path(@note)
    assert_redirected_to root_path

    log_in_as(@user)
    get user_note_path(@note)
    assert_redirected_to user_note_path(@note)
  end

end
