require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest

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
  
  test "create messages" do
    [@leader_pname, @subleader_pname, @common_pname, @visitor_pname].each do |pname|
      log_in_as(pname.user)
      post group_messages_path(@group),
          params: { message: {content: "Test Note"} }
      assert_redirected_to group_messages_path(@group)
    end

    [@other_pname].each do |pname|
      log_in_as(pname.user)
      post group_messages_path(@group),
          params: { message: {content: "Test Note"} }
      assert_redirected_to root_path
    end
  end

  
end