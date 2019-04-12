require 'test_helper'

class GroupsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @group = groups(:group1)

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

  test "works" do
    [@leader, @subleader, @common, @visitor, @other].each do |user|
      log_in_as(user)
      get works_group_path(@group)
      assert_template 'groups/works'
    end
  end

  test "show open group" do # group home
    [@leader, @subleader, @common, @visitor].each do |user|
      log_in_as(user)
      get group_path(@group)
      assert_template 'groups/show'
    end

    [@other].each do |user|
      log_in_as(user)
      get group_path(@group)
      assert_redirected_to root_path
    end
  end

  test "members" do
    [@leader, @subleader, @common, @visitor].each do |user|
      log_in_as(user)
      get members_group_path(@group)
      assert_template 'groups/members'
    end

    [@other].each do |user|
      log_in_as(user)
      get members_group_path(@group)
      assert_redirected_to root_path
    end
  end

  test "messages" do
    [@leader, @subleader, @common, @visitor].each do |user|
      log_in_as(user)
      get messages_group_path(@group)
      assert_template 'groups/messages'
    end

    [@other].each do |user|
      log_in_as(user)
      get messages_group_path(@group)
      assert_redirected_to root_path
    end
  end

  test "new/create group" do
    log_in_as(@other)
    get new_group_path
    assert_template 'groups/new'

    assert_difference 'Group.count', 0 do
      post groups_path, params: { group: { name: "Test Group", description: "This is a test.",
                                           pen_name_id: @leader_pname.id} }
    end
    assert_redirected_to root_path

    assert_difference 'Group.count', 1 do
      post groups_path, params: { group: { name: "Test Group", description: "This is a test.",
                                           pen_name_id: @other_pname.id} }
    end
    assert_redirected_to @other
    assert Group.first.is_leader?(@other_pname)
  end

  test "edit/update group" do
    [@leader, @subleader].each do |user|
      log_in_as(@leader)
      get edit_group_path(@group)
      assert_template 'groups/edit'

      patch group_path(@group), params: { group: { name: @group.name, description: "This is a edit test." } }
      assert_redirected_to @group
    end

    [@common, @visitor, @other].each do |user|
      log_in_as(@other)
      get edit_group_path(@group)
      assert_redirected_to root_path

      patch group_path(@group), params: { group: { name: @group.name, description: "This is a edit test as a wrong user." } }
      assert_redirected_to root_path
    end
  end

  test "delete group" do
    [@leader, @subleader, @common, @visitor, @other].each do |user|
      log_in_as(user)
      assert_difference 'Group.count', 0 do
        delete group_path(@group)
      end
      assert_redirected_to root_path
    end

    log_in_as(@other)
    assert_difference 'Group.count', 1 do
      post groups_path, params: { group: { name: "Test Group", description: "This is a test.",
                                           pen_name_id: @other_pname.id} }
    end
    assert_redirected_to @other

    assert_difference 'Group.count', -1 do
      delete group_path(@other_pname.groups.first)
    end
    assert_redirected_to @other
  end

  test "join/unjoin" do
    [@leader, @subleader, @common, @visitor].each do |user|
      log_in_as(user)
      pen_name = @group.get_user_member(user)
      get join_group_path(@group), params: { group: { pen_name_id: pen_name.id } }
      assert_redirected_to root_path
    end

    [@leader].each do |user|
      log_in_as(user)
      pen_name = @group.get_user_member(user)
      get unjoin_group_path(@group), params: { group: { pen_name_id: pen_name.id } }
      assert_redirected_to root_path
    end

    [@subleader, @common, @visitor].each do |user|
      log_in_as(user)
      pen_name = @group.get_user_member(user)
      get unjoin_group_path(@group), params: { group: { pen_name_id: pen_name.id } }
      assert_redirected_to groups_path
      assert_not @group.is_member?(pen_name)
    end

    [@leader, @subleader, @common, @visitor].each do |user|
      log_in_as(user)
      get join_group_path(@group), params: { group: { pen_name_id: @other_pname.id } }
      assert_redirected_to root_path
    end

    log_in_as(@other)
    [@leader_pname, @subleader_pname, @common_pname, @visitor_pname].each do |pname|
      get unjoin_group_path(@group), params: { group: { pen_name_id: pname.id } }
      assert_redirected_to root_path
    end

    get join_group_path(@group), params: { group: { pen_name_id: @other_pname.id } }
    assert_redirected_to groups_path
    assert @group.is_member?(@other_pname)
    get unjoin_group_path(@group), params: { group: { pen_name_id: @other_pname.id } }
    assert_redirected_to groups_path
    assert_not @group.is_member?(@other_pname)
  end

  test "to_open/to_close" do
    [@leader, @subleader].each do |user|
      log_in_as(user)
      get to_close_group_path(@group)
      assert_redirected_to group_path(@group)
      get to_open_group_path(@group)
      assert_redirected_to group_path(@group)
    end # -> open

    log_in_as(@visitor)
    assert_not @group.is_member?(@visitor_pname)
    get join_group_path(@group), params: { group: { pen_name_id: @visitor_pname.id } }
    assert @group.is_member?(@visitor_pname)

    [@common, @visitor].each do |user|
      log_in_as(user)
      get to_close_group_path(@group)
      assert_redirected_to root_path
      get to_open_group_path(@group)
      assert_redirected_to root_path
    end # -> open

    log_in_as(@other)
    get to_close_group_path(@group)
    assert_redirected_to root_path
    get to_open_group_path(@group)
    assert_redirected_to root_path
    # -> open

    assert @group.is_open?
    assert_not @group.is_member?(@other_pname)

    log_in_as(@other)
    get join_group_path(@group), params: { group: { pen_name_id: @other_pname.id } }
    assert_redirected_to groups_path
    get unjoin_group_path(@group), params: { group: { pen_name_id: @other_pname.id } }
    assert_redirected_to groups_path

    log_in_as(@leader)
    get to_close_group_path(@group)
    assert_redirected_to group_path(@group)

    log_in_as(@other)
    get join_group_path(@group), params: { group: { pen_name_id: @other_pname.id } }
    assert_redirected_to root_path
  end

  test "position @leader" do
    leader_id = Membership::POS_LEADER
    subleader_id = Membership::POS_SUBLEADER
    common_id = Membership::POS_COMMON
    visitor_id = Membership::POS_VISITOR

    log_in_as(@leader)

    [leader_id, subleader_id, common_id, visitor_id].each do |to_pos_id|
      get position_group_path(@group),
          params: { group: { pen_name_id: @leader_pname.id, position: to_pos_id } }
      assert_redirected_to root_path
    end

    [leader_id, subleader_id].each do |to_pos_id|
      get position_group_path(@group),
          params: { group: { pen_name_id: @subleader_pname.id, position: to_pos_id } }
      assert_redirected_to root_path
    end
    [common_id, visitor_id].each do |to_pos_id|
      get position_group_path(@group),
          params: { group: { pen_name_id: @subleader_pname.id, position: to_pos_id } }
      assert_redirected_to members_group_path(@group)
      get position_group_path(@group),
          params: { group: { pen_name_id: @subleader_pname.id, position: subleader_id } }
      assert_redirected_to members_group_path(@group)
    end

    [leader_id, common_id].each do |to_pos_id|
      get position_group_path(@group),
          params: { group: { pen_name_id: @common_pname.id, position: to_pos_id } }
      assert_redirected_to root_path
    end
    [subleader_id, visitor_id].each do |to_pos_id|
      get position_group_path(@group),
          params: { group: { pen_name_id: @common_pname.id, position: to_pos_id } }
      assert_redirected_to members_group_path(@group)
      get position_group_path(@group),
          params: { group: { pen_name_id: @common_pname.id, position: common_id } }
      assert_redirected_to members_group_path(@group)
    end

    [leader_id, visitor_id].each do |to_pos_id|
      get position_group_path(@group),
          params: { group: { pen_name_id: @visitor_pname.id, position: to_pos_id } }
      assert_redirected_to root_path
    end
    [subleader_id, common_id].each do |to_pos_id|
      get position_group_path(@group),
          params: { group: { pen_name_id: @visitor_pname.id, position: to_pos_id } }
      assert_redirected_to members_group_path(@group)
      get position_group_path(@group),
          params: { group: { pen_name_id: @visitor_pname.id, position: visitor_id } }
      assert_redirected_to members_group_path(@group)
    end

  end

  test "position @subleader" do
    leader_id = Membership::POS_LEADER
    subleader_id = Membership::POS_SUBLEADER
    common_id = Membership::POS_COMMON
    visitor_id = Membership::POS_VISITOR

    log_in_as(@subleader)

    [leader_id, subleader_id, common_id, visitor_id].each do |to_pos_id|
      get position_group_path(@group),
          params: { group: { pen_name_id: @leader_pname.id, position: to_pos_id } }
      assert_redirected_to root_path
    end

    [leader_id, subleader_id, common_id, visitor_id].each do |to_pos_id|
      get position_group_path(@group),
          params: { group: { pen_name_id: @subleader_pname.id, position: to_pos_id } }
      assert_redirected_to root_path
    end

    [leader_id, subleader_id, common_id].each do |to_pos_id|
      get position_group_path(@group),
          params: { group: { pen_name_id: @common_pname.id, position: to_pos_id } }
      assert_redirected_to root_path
    end
    [visitor_id].each do |to_pos_id|
      get position_group_path(@group),
          params: { group: { pen_name_id: @common_pname.id, position: to_pos_id } }
      assert_redirected_to members_group_path(@group)
      get position_group_path(@group),
          params: { group: { pen_name_id: @common_pname.id, position: common_id } }
      assert_redirected_to members_group_path(@group)
    end

    [leader_id, subleader_id, visitor_id].each do |to_pos_id|
      get position_group_path(@group),
          params: { group: { pen_name_id: @visitor_pname.id, position: to_pos_id } }
      assert_redirected_to root_path
    end
    [common_id].each do |to_pos_id|
      get position_group_path(@group),
          params: { group: { pen_name_id: @visitor_pname.id, position: to_pos_id } }
      assert_redirected_to members_group_path(@group)
      get position_group_path(@group),
          params: { group: { pen_name_id: @visitor_pname.id, position: visitor_id } }
      assert_redirected_to members_group_path(@group)
    end

  end

  test "position @common/@visitor/@other" do
    leader_id = Membership::POS_LEADER
    subleader_id = Membership::POS_SUBLEADER
    common_id = Membership::POS_COMMON
    visitor_id = Membership::POS_VISITOR

    [@common, @visitor, @other].each do |user|

      log_in_as(user)

      [leader_id, subleader_id, common_id, visitor_id].each do |to_pos_id|
        get position_group_path(@group),
            params: { group: { pen_name_id: @leader_pname.id, position: to_pos_id } }
        assert_redirected_to root_path
      end

      [leader_id, subleader_id, common_id, visitor_id].each do |to_pos_id|
        get position_group_path(@group),
            params: { group: { pen_name_id: @subleader_pname.id, position: to_pos_id } }
        assert_redirected_to root_path
      end

      [leader_id, subleader_id, common_id, visitor_id].each do |to_pos_id|
        get position_group_path(@group),
            params: { group: { pen_name_id: @common_pname.id, position: to_pos_id } }
        assert_redirected_to root_path
      end

      [leader_id, subleader_id, common_id, visitor_id].each do |to_pos_id|
        get position_group_path(@group),
            params: { group: { pen_name_id: @visitor_pname.id, position: to_pos_id } }
        assert_redirected_to root_path
      end
    end

  end

  test "change_leader" do
    leader_id = Membership::POS_LEADER
    subleader_id = Membership::POS_SUBLEADER
    common_id = Membership::POS_COMMON

    [@subleader, @common, @visitor, @other].each do |user|
      log_in_as(user)

      get change_leader_group_path(@group)
      assert_redirected_to root_path
    end

    log_in_as(@leader)

    assert_equal @group.get_position_id(@leader_pname), leader_id
    assert_equal @group.get_position_id(@subleader_pname), subleader_id
    assert_equal @group.get_position_id(@common_pname), common_id

    get position_group_path(@group),
        params: { group: { pen_name_id: @common_pname.id, position: subleader_id } }
    assert_redirected_to members_group_path(@group)

    assert_equal @group.get_position_id(@leader_pname), leader_id
    assert_equal @group.get_position_id(@subleader_pname), subleader_id
    assert_equal @group.get_position_id(@common_pname), subleader_id

    get change_leader_group_path(@group)
    assert_redirected_to members_group_path(@group)

    assert_equal @group.get_position_id(@leader_pname), subleader_id
    assert_equal @group.get_position_id(@subleader_pname), leader_id
    assert_equal @group.get_position_id(@common_pname), subleader_id
  end

end
