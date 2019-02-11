require 'test_helper'

class MemoInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @note = notes(:orange)
  end

  test "memo interface" do
    skip "hold on"
    
    log_in_as(@user)
    get new_note_memo_path(@note)
#    assert_select 'input[type="file"]'
    # 無効な送信
    post note_memos_path(@note), params: { memo: { content: "" } }
    assert_select 'div#error_explanation'
    # 有効な送信
    content = "This memo really ties the room together"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Memo.count', 1 do
      post note_memos_path(@note), params: { memo:
                                      { content: content,
                                        picture: picture } }
    end
    assert assigns(:memo).picture?
    follow_redirect!
    assert_match content, response.body
    # 投稿を削除する
    assert_select 'a', 'delete'
    first_memo = @user.memos.paginate(page: 1).first
    assert_difference 'Memo.count', -1 do
      delete note_memo_path(@note, first_memo)
    end
    # 違うユーザーのプロフィールにアクセスする
    get user_path(users(:archer))
    assert_select 'a', { text: 'delete', count: 0 }
  end
  
end