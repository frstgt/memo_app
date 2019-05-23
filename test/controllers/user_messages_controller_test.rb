require 'test_helper'

class UserMessagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user1)
    @user_pname = pen_names(:user1_pen_name1)
    @room = user_rooms(:user1_room1)
    @message = messages(:user1_message1)

    @other_user = users(:user9)
    @other_pname = pen_names(:user9_pen_name1)
    @closed_room = user_rooms(:user1_room2)
  end

  test "create message at opened room" do
    log_in_as(@other_user)
    assert_difference '@room.messages.count', 1 do
      post room_messages_path(@room),
            params: { message: {content: "This is a test.", pen_name_id: @other_pname.id} }
    end
    assert_redirected_to user_room_path(@room)

    log_in_as(@user)
    assert_difference '@room.messages.count', 1 do
      post room_messages_path(@room),
            params: { message: {content: "This is a test.", pen_name_id: @user_pname.id} }
    end
    assert_redirected_to user_room_path(@room)
  end

  test "create message at closed room" do
    log_in_as(@other_user)
    assert_difference '@closed_room.messages.count', 0 do
      post room_messages_path(@closed_room),
            params: { message: {content: "This is a test.", pen_name_id: @other_pname.id} }
    end
    assert_redirected_to root_path

    log_in_as(@user)
    assert_difference '@closed_room.messages.count', 1 do
      post room_messages_path(@closed_room),
            params: { message: {content: "This is a test.", pen_name_id: @user_pname.id} }
    end
    assert_redirected_to user_room_path(@closed_room)
  end

end
