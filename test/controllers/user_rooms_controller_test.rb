require 'test_helper'

class UserRoomsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user1)
    @user_pname = pen_names(:user1_pen_name1)
    @room = user_rooms(:user1_room1)

    @other_user = users(:user2)
    @closed_room = user_rooms(:user1_room2)
  end
  
  test "show opened room" do
    log_in_as(@other_user)
    get user_room_path(@room)
    assert_template 'user_rooms/show'

    log_in_as(@user)
    get user_room_path(@room)
    assert_template 'user_rooms/show'
  end

  test "show closed room" do
    log_in_as(@other_user)
    get user_room_path(@closed_room)
    assert_redirected_to root_path

    log_in_as(@user)
    get user_room_path(@closed_room)
    assert_template 'user_rooms/show'
  end
  
  test "new/create room" do
    log_in_as(@user)
    get new_user_room_path
    assert_template 'user_rooms/new'

    assert_difference '@user.user_rooms.count', 1 do
      post user_rooms_path,
            params: { user_room: {title: "Test Room", outline: "This is a test.",
                      pen_name_id: @user_pname.id} }
    end
    assert_redirected_to @user
  end

  test "edit/update room" do
    log_in_as(@other_user)
    get edit_user_room_path(@room)
    assert_redirected_to root_path

    patch user_room_path(@room), params: { user_room: { title: @room.title, outline: "This is a edit test as a wrong user." } }
    assert_redirected_to root_path

    log_in_as(@user)
    get edit_user_room_path(@room)
    assert_template 'user_rooms/edit'

    patch user_room_path(@room), params: { user_room: { title: @room.title, outline: "This is a edit test." } }
    assert_redirected_to @room
  end

  test "delete room" do
    log_in_as(@other_user)
    assert_difference '@user.user_rooms.count', 0 do
      delete user_room_path(@room)
    end
    assert_redirected_to root_path

    log_in_as(@user)
    assert_difference '@user.user_rooms.count', -1 do
      delete user_room_path(@room)
    end
    assert_redirected_to @user
  end

end
