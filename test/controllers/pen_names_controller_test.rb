require 'test_helper'

class PenNamesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "should get new" do
    skip "what's wrong?"
    log_in_as(@user)
    get pen_names_new_url
    assert_response :success
  end

end
