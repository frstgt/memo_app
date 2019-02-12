require 'test_helper'

class PenNamesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get pen_names_new_url
    assert_response :success
  end

end
