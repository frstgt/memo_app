require 'test_helper'

class UserNotesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user1)
    @user_pname = pen_names(:user1_pen_name1)
    @note = user_notes(:user1_note1)

    @other_user = users(:user2)
    @closed_note = user_notes(:user1_note2)
    @group = groups(:group1)
  end
  
  test "show opened note" do
    log_in_as(@other_user)
    get user_note_path(@note)
    assert_template 'user_notes/show'

    log_in_as(@user)
    get user_note_path(@note)
    assert_template 'user_notes/show'
  end
  test "show closed note" do
    log_in_as(@other_user)
    get user_note_path(@closed_note)
    assert_redirected_to root_path

    log_in_as(@user)
    get user_note_path(@closed_note)
    assert_template 'user_notes/show'
  end

  test "set point to note" do
    log_in_as(@other_user)
    get set_point_note_path(@note), params: { note: {point: 0} }
    assert_redirected_to user_note_path(@note)

    log_in_as(@user)
    get set_point_note_path(@note), params: { note: {point: 0} }
    assert_redirected_to root_path
  end
  
  test "new/create note" do
    log_in_as(@user)
    get new_user_note_path
    assert_template 'user_notes/new'

    assert_difference '@user.user_notes.count', 1 do
      post user_notes_path,
            params: { user_note: {title: "Test Note", outline: "This is a test.",
                      pen_name_id: @user_pname.id} }
    end
    assert_redirected_to @user
  end

  test "edit/update note" do
    log_in_as(@other_user)
    get edit_user_note_path(@note)
    assert_redirected_to root_path

    patch user_note_path(@note), params: { user_note: { title: @note.title, outline: "This is a edit test as a wrong user." } }
    assert_redirected_to root_path

    log_in_as(@user)
    get edit_user_note_path(@note)
    assert_template 'user_notes/edit'

    patch user_note_path(@note), params: { user_note: { title: @note.title, outline: "This is a edit test." } }
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

  test "move to group_note" do
    log_in_as(@other_user)
    assert_difference '@user.user_notes.count', 0 do
      get move_user_note_path(@note, {group_id: @group.id})
    end
    assert_redirected_to root_path

    log_in_as(@user)
    assert_difference '@user.user_notes.count', -1 do
      get move_user_note_path(@note, {group_id: @group.id})
    end
    assert_redirected_to @user
  end

end
