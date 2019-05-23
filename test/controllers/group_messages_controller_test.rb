require 'test_helper'

class GroupMessagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @group = groups(:group1)
    @room = group_rooms(:group1_room1)
    @message = messages(:group1_message1)

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
  
  test "create message at opened room" do
    [@leader_pname, @subleader_pname, @common_pname, @visitor_pname, @other_pname].each do |pen_name|
      log_in_as(pen_name.user)
      assert_difference '@room.messages.count', 1 do
        post room_messages_path(@room),
              params: { message: {content: "This is a test.", pen_name_id: pen_name.id} }
      end
      assert_redirected_to group_group_room_path(@group, @room)
    end
  end

  test "create message at closed room" do
    [@leader_pname, @subleader_pname, @common_pname].each do |pen_name|
      log_in_as(pen_name.user)
      assert_difference '@closed_room.messages.count', 1 do
        post room_messages_path(@closed_room),
              params: { message: {content: "This is a test.", pen_name_id: pen_name.id} }
      end
      assert_redirected_to group_group_room_path(@group, @closed_room)
    end

    [@visitor_pname, @other_pname].each do |pen_name|
      log_in_as(pen_name.user)
      assert_difference '@closed_room.messages.count', 0 do
        post room_messages_path(@closed_room),
              params: { message: {content: "This is a test as a wrong user.", pen_name_id: pen_name.id} }
      end
      assert_redirected_to root_path
    end
  end

end