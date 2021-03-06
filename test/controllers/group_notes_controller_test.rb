require 'test_helper'

class GroupNotesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @group = groups(:group1)
    @note = group_notes(:group1_note1)

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
    @closed_note = group_notes(:group1_note2)
  end

  test "show opened group note" do
    [@leader, @subleader, @common, @visitor, @other].each do |user|
      log_in_as(user)
      get group_group_note_path(@group, @note)
      assert_template 'group_notes/show'
    end
  end
  test "show closed group note" do
    [@leader, @subleader, @common].each do |user|
      log_in_as(user)
      get group_group_note_path(@group, @closed_note)
      assert_template 'group_notes/show'
    end

    [@visitor, @other].each do |user|
      log_in_as(user)
      get group_group_note_path(@group, @closed_note)
      assert_redirected_to root_path
    end
  end

  test "set point to group note" do
    [@leader, @subleader, @common, @visitor].each do |user|
      log_in_as(user)
      get set_point_note_path(@note), params: { note: {point: 0} }
      assert_redirected_to root_path
    end

    [@other].each do |user|
      log_in_as(user)
      get set_point_note_path(@note), params: { note: {point: 0} }
      assert_redirected_to group_group_note_path(@group, @note)
    end
  end
  
  test "new/create group note" do
    [@leader, @subleader, @common].each do |user|
      log_in_as(user)

      get new_group_group_note_path(@group)
      assert_template 'group_notes/new'

      assert_difference '@group.group_notes.count', 1 do
        post group_group_notes_path(@group),
             params: { group_note: {title: "Test Note", outline: "This is a test."} }
      end
      assert_redirected_to @group
    end

    [@visitor, @other].each do |user|
      log_in_as(user)

      get new_group_group_note_path(@group)
      assert_redirected_to root_path

      assert_difference '@group.group_notes.count', 0 do
        post group_group_notes_path(@group),
             params: { group_note: {title: "Test Note", outline: "This is a test."} }
      end
      assert_redirected_to root_path
    end
  end

  test "edit/update group note" do
    [@leader, @subleader].each do |user|
      log_in_as(user)

      get edit_group_group_note_path(@group, @note)
      assert_template 'group_notes/edit'

      patch group_group_note_path(@group, @note),
            params: { group_note: {title: "Test Note", outline: "This is a edit test."} }
      assert_redirected_to group_group_note_path(@group, @note)
    end

    [@common, @visitor, @other].each do |user|
      log_in_as(user)

      get edit_group_group_note_path(@group, @note)
      assert_redirected_to root_path

      patch group_group_note_path(@group, @note),
            params: { group_note: {title: "Test Note", outline: "This is a edit test."} }
      assert_redirected_to root_path
    end
  end

  test "delete group note" do
    [@leader, @subleader].each do |user|
      log_in_as(user)

      # new note
      assert_difference '@group.group_notes.count', 1 do
        post group_group_notes_path(@group),
             params: { group_note: {title: "Test Note", outline: "This is a test."} }
      end
      assert_redirected_to @group

      # delete note
      assert_difference '@group.group_notes.count', -1 do
        delete group_group_note_path(@group, @group.group_notes.first)
      end
      assert_redirected_to @group
    end

    [@common, @visitor, @other].each do |user|
      log_in_as(user)

      assert_difference '@group.group_notes.count', 0 do
        delete group_group_note_path(@group, @note)
      end
      assert_redirected_to root_path
    end
  end

  test "move to user note" do
    [@leader_pname, @subleader_pname, @common_pname].each do |pname|
      log_in_as(@leader)
      assert_difference '@group.group_notes.count', 1 do
        post group_group_notes_path(@group),
             params: { group_note: {title: "Test Note", outline: "This is a test.", pen_name_id: pname.id} }
      end
      assert_redirected_to @group

      log_in_as(pname.user)
      assert_difference '@group.group_notes.count', -1 do
        get move_group_group_note_path(@group, @group.group_notes.first)
      end
      assert_redirected_to @group
    end

    [@visitor_pname].each do |pname|
      log_in_as(@leader)
      assert_difference '@group.group_notes.count', 1 do
        post group_group_notes_path(@group),
             params: { group_note: {title: "Test Note", outline: "This is a test.", pen_name_id: pname.id} }
      end
      assert_redirected_to @group

      log_in_as(pname.user)
      assert_difference '@group.group_notes.count', 0 do
        get move_group_group_note_path(@group, @group.group_notes.first)
      end
      assert_redirected_to root_path
    end

    [@other].each do |user|
      log_in_as(user)

      assert_difference '@group.group_notes.count', 0 do
        get move_group_group_note_path(@group, @note)
      end
      assert_redirected_to root_path
    end
  end

end
