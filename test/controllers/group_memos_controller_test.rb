require 'test_helper'

class GroupMemosControllerTest < ActionDispatch::IntegrationTest

  def setup
    @group = groups(:group1)
    @note = group_notes(:group1_note1)
    @memo = group_memos(:group1_memo1)

    @leader    = users(:user1)
    @leader_pname = pen_names(:user1_pen_name1)
    @subleader = users(:user2)
    @subleader_pname = pen_names(:user2_pen_name1)
    @common    = users(:user3)
    @common_pname = pen_names(:user3_pen_name1)
    @visitor   = users(:user4)
    @visitor_pname = pen_names(:user4_pen_name1)

    @other     = users(:user9)
    @other_pname = pen_names(:user9_pen_name1)
  end
  
  test "new/create memo" do
    [@leader, @subleader, @common].each do |user|
      log_in_as(user)
      get new_group_group_note_group_memo_path(@group, @note, @memo)
      assert_template 'group_memos/new'
    end
    [@visitor, @other].each do |user|
      log_in_as(user)
      get new_group_group_note_group_memo_path(@group, @note, @memo)
      assert_redirected_to root_path
    end

    [@leader, @subleader, @common].each do |user|
      log_in_as(user)
      assert_difference '@note.group_memos.count', 1 do
        post group_group_note_group_memos_path(@group, @note, @memo),
              params: { group_memo: {content: "This is a test.", number: 1} }
      end
      assert_redirected_to group_group_note_path(@group, @note)
    end
    [@visitor, @other].each do |user|
      log_in_as(user)
      assert_difference '@note.group_memos.count', 0 do
        post group_group_note_group_memos_path(@group, @note, @memo),
              params: { group_memo: {content: "This is a test as a wrong user.", number: 1} }
      end
      assert_redirected_to root_path
    end
  end

  test "edit/update memo" do
    [@leader, @subleader, @common].each do |user|
      log_in_as(user)
      get edit_group_group_note_group_memo_path(@group, @note, @memo)
      assert_template 'group_memos/edit'
    end
    [@visitor, @other].each do |user|
      log_in_as(user)
      get edit_group_group_note_group_memo_path(@group, @note, @memo)
      assert_redirected_to root_path
    end

    [@leader, @subleader, @common].each do |user|
      log_in_as(user)
      patch group_group_note_group_memo_path(@group, @note, @memo),
            params: { group_memo: { content: "This is a edit test.", number: @memo.number } }
      assert_redirected_to group_group_note_path(@group, @note)
    end
    [@visitor, @other].each do |user|
      log_in_as(user)
      patch group_group_note_group_memo_path(@group, @note, @memo),
            params: { group_memo: { content: "This is a edit test as a wrong user.", number: @memo.number } }
      assert_redirected_to root_path
    end
  end

  test "delete memo" do
    [@leader, @subleader, @common].each do |user|
      log_in_as(user)

      assert_difference '@note.group_memos.count', 1 do
        post group_group_note_group_memos_path(@group, @note, @memo),
              params: { group_memo: {content: "This is a test.", number: 1} }
      end

      assert_difference '@note.group_memos.count', -1 do
        delete group_group_note_group_memo_path(@group, @note, @note.group_memos.last)
      end
      assert_redirected_to group_group_note_path(@group, @note)
    end
    [@visitor, @other].each do |user|
      log_in_as(user)
      assert_difference '@note.group_memos.count', 0 do
        delete group_group_note_group_memo_path(@group, @note, @memo)
      end
      assert_redirected_to root_path
    end
  end

end