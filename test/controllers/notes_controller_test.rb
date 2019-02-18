require 'test_helper'

class NotesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @note = notes(:cat)

    @other_user = users(:archer)
  end
  
  test "show note" do
    log_in_as(@other_user)
    get note_path(@note)
    assert_redirected_to root_path

    log_in_as(@user)
    get note_path(@note)
    assert_template 'notes/show'
  end
  
  test "new/create note" do
    log_in_as(@user)
    get new_note_path
    assert_template 'notes/new'

    assert_difference '@user.notes.count', 1 do
      post notes_path, params: {note: {title: "Test Note", description: "This is a test."} }
    end
    assert_redirected_to @user
  end

  test "edit/update note" do
    log_in_as(@other_user)
    get edit_note_path(@note)
    assert_redirected_to root_path

    patch note_path(@note), params: { note: { title: @note.title, description: "This is a edit test as a wrong user." } }
    assert_redirected_to root_path

    log_in_as(@user)
    get edit_note_path(@note)
    assert_template 'notes/edit'

    patch note_path(@note), params: { note: { title: @note.title, description: "This is a edit test." } }
    assert_redirected_to @user
  end

  test "delete note" do
    log_in_as(@other_user)
    assert_difference '@user.notes.count', 0 do
      delete note_path(@note)
    end
    assert_redirected_to root_path

    log_in_as(@user)
    assert_difference '@user.notes.count', -1 do
      delete note_path(@note)
    end
    assert_redirected_to @user
  end

end
