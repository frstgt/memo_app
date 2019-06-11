require 'test_helper'

class GroupRoomsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @group = groups(:group1)
    @room = group_rooms(:group1_room1)

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
    @closed_room = group_rooms(:group1_room2)
  end

  test "show opened group room" do
    [@leader, @subleader, @common, @visitor, @other].each do |user|
      log_in_as(user)
      get group_group_room_path(@group, @room)
      assert_template 'group_rooms/show'
    end
  end
  test "show closed group room" do
    [@leader, @subleader, @common].each do |user|
      log_in_as(user)
      get group_group_room_path(@group, @closed_room)
      assert_template 'group_rooms/show'
    end

    [@visitor, @other].each do |user|
      log_in_as(user)
      get group_group_room_path(@group, @closed_room)
      assert_redirected_to root_path
    end
  end
  
  test "new/create group room" do
    [@leader, @subleader, @common].each do |user|
      log_in_as(user)

      get new_group_group_room_path(@group)
      assert_template 'group_rooms/new'

      assert_difference '@group.group_rooms.count', 1 do
        post group_group_rooms_path(@group),
             params: { group_room: {title: "Test Room", outline: "This is a test."} }
      end
      assert_redirected_to @group
    end

    [@visitor, @other].each do |user|
      log_in_as(user)

      get new_group_group_room_path(@group)
      assert_redirected_to root_path

      assert_difference '@group.group_rooms.count', 0 do
        post group_group_rooms_path(@group),
             params: { group_room: {title: "Test Room", outline: "This is a test."} }
      end
      assert_redirected_to root_path
    end
  end

  test "edit/update group room" do
    [@leader, @subleader].each do |user|
      log_in_as(user)

      get edit_group_group_room_path(@group, @room)
      assert_template 'group_rooms/edit'

      patch group_group_room_path(@group, @room),
            params: { group_room: {title: "Test Room", outline: "This is a edit test."} }
      assert_redirected_to group_group_room_path(@group, @room)
    end

    [@common, @visitor, @other].each do |user|
      log_in_as(user)

      get edit_group_group_room_path(@group, @room)
      assert_redirected_to root_path

      patch group_group_room_path(@group, @room),
            params: { group_room: {title: "Test Room", outline: "This is a edit test."} }
      assert_redirected_to root_path
    end
  end

  test "delete group room" do
    [@leader, @subleader].each do |user|
      log_in_as(user)

      assert_difference '@group.group_rooms.count', 1 do
        post group_group_rooms_path(@group),
             params: { group_room: {title: "Test Room", outline: "This is a test."} }
      end
      assert_redirected_to @group

      assert_difference '@group.group_rooms.count', -1 do
        delete group_group_room_path(@group, @group.group_rooms.first)
      end
      assert_redirected_to @group
    end

    [@common, @visitor, @other].each do |user|
      log_in_as(user)

      assert_difference '@group.group_rooms.count', 0 do
        delete group_group_room_path(@group, @room)
      end
      assert_redirected_to root_path
    end
  end

end
