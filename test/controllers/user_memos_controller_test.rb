require 'test_helper'

class UserMemosControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user1)
    @note = user_notes(:user1_note1)
    @memo = user_memos(:user1_memo1)

    @other_user = users(:user2)
  end

  test "new/create memo" do
    log_in_as(@other_user)
    get new_user_note_user_memo_path(@note)
    assert_redirected_to root_path

    log_in_as(@user)
    get new_user_note_user_memo_path(@note)
    assert_template 'user_memos/new'

    assert_difference '@note.user_memos.count', 1 do
      post user_note_user_memos_path(@note), params: { user_memo: {content: "This is a test.", number: 1} }
    end
    assert_redirected_to @note
  end

  test "edit/update memo" do
    log_in_as(@other_user)
    get edit_user_note_user_memo_path(@note, @memo)
    assert_redirected_to root_path

    patch user_note_user_memo_path(@note, @memo), params: { user_memo: { content: "This is a edit test as a wrong user.", number: @memo.number } }
    assert_redirected_to root_path

    log_in_as(@user)
    get edit_user_note_user_memo_path(@note, @memo)
    assert_template 'user_memos/edit'

    patch user_note_user_memo_path(@note, @memo), params: { user_memo: { content: "This is a edit test.", number: @memo.number } }
    assert_redirected_to @note
  end

  test "delete memo" do
    log_in_as(@other_user)
    assert_difference '@note.user_memos.count', 0 do
      delete user_note_user_memo_path(@note, @memo)
    end
    assert_redirected_to root_path

    log_in_as(@user)
    assert_difference '@note.user_memos.count', -1 do
      delete user_note_user_memo_path(@note, @memo)
    end
    assert_redirected_to @note
  end

end
