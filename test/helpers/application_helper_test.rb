require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         'Memo App'
    assert_equal full_title("Help"), 'Help | Memo App'
  end
end