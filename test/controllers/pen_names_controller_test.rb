require 'test_helper'

class PenNamesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "should get new" do
    log_in_as(@user)
    p is_logged_in?
    get new_pen_name_url
    assert_response :success
  end

end
