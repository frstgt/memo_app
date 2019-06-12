require 'test_helper'

class PenNamesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user1)
    @pen_name = pen_names(:user1_pen_name1)

    @other_user = users(:user9)
    @closed_pen_name = pen_names(:user1_pen_name2)
    @closed_pen_name_with_keyword = pen_names(:user1_pen_name3)
  end

  test "show opened pen_name" do
    log_in_as(@other_user)
    get pen_name_path(@pen_name)
    assert_template 'pen_names/show'

    log_in_as(@user)
    get pen_name_path(@pen_name)
    assert_template 'pen_names/show'
  end

  test "show closed pen_name" do
    log_in_as(@other_user)
    get pen_name_path(@closed_pen_name)
    assert_redirected_to root_path

    log_in_as(@user)
    get pen_name_path(@closed_pen_name)
    assert_template 'pen_names/show'
  end

  test "show opened pen_name with keyword" do
    log_in_as(@other_user)
    get pen_name_path(@closed_pen_name_with_keyword)
    assert_template 'pen_names/show'

    log_in_as(@user)
    get pen_name_path(@closed_pen_name_with_keyword)
    assert_template 'pen_names/show'
  end

  test "new/create pen_name" do
    log_in_as(@user)
    get new_pen_name_path
    assert_template 'pen_names/new'

    assert_difference '@user.pen_names.count', 1 do
      post pen_names_path, params: { pen_name: { name: "Test PenName", outline: "This is a test."} }
    end
    assert_redirected_to @user
  end

  test "edit/update pen_name" do
    log_in_as(@other_user)
    get edit_pen_name_path(@pen_name)
    assert_redirected_to root_path

    patch pen_name_path(@pen_name), params: { pen_name: { name: @pen_name.name, outline: "This is a test as a wrong user." } }
    assert_redirected_to root_path

    log_in_as(@user)
    get edit_pen_name_path(@pen_name)
    assert_template 'pen_names/edit'

    patch pen_name_path(@pen_name), params: { pen_name: { name: @pen_name, outline: "This is a test." } }
    assert_redirected_to @pen_name
  end

  test "delete pen_name" do
    log_in_as(@other_user)
    assert_difference '@user.pen_names.count', 0 do
      delete pen_name_path(@pen_name)
    end
    assert_redirected_to root_path

    log_in_as(@user)
    assert_difference '@user.pen_names.count', -1 do
      delete pen_name_path(@closed_pen_name)
    end
    assert_redirected_to @user
  end

end
