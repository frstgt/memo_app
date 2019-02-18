require 'test_helper'

class MemosControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @note = notes(:cat)
    @memo = memos(:apple)

    @other_user = users(:archer)
  end

  test "new/create memo" do
    log_in_as(@other_user)
    get new_note_memo_path(@note)
    assert_redirected_to root_path

    log_in_as(@user)
    get new_note_memo_path(@note)
    assert_template 'memos/new'

    assert_difference '@note.memos.count', 1 do
      post note_memos_path(@note), params: {memo: {content: "This is a test.", number: 1} }
    end
    assert_redirected_to @note
  end

  test "edit/update memo" do
    log_in_as(@other_user)
    get edit_note_memo_path(@note, @memo)
    assert_redirected_to root_path

    patch note_memo_path(@note, @memo), params: { memo: { content: "This is a edit test as a wrong user.", number: @memo.number } }
    assert_redirected_to root_path

    log_in_as(@user)
    get edit_note_memo_path(@note, @memo)
    assert_template 'memos/edit'

    patch note_memo_path(@note, @memo), params: { memo: { content: "This is a edit test.", number: @memo.number } }
    assert_redirected_to @note
  end

  test "delete memo" do
    log_in_as(@other_user)
    assert_difference '@note.memos.count', 0 do
      delete note_memo_path(@note, @memo)
    end
    assert_redirected_to root_path

    log_in_as(@user)
    assert_difference '@note.memos.count', -1 do
      delete note_memo_path(@note, @memo)
    end
    assert_redirected_to @note
  end

end
