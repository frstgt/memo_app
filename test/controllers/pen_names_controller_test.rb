require 'test_helper'

class PenNamesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @pen_name = pen_names(:car)

    @other_user = users(:archer)
  end
  
  test "show pen_name" do
    log_in_as(@other_user)
    get pen_name_path(@pen_name)
    assert_redirected_to root_path

    log_in_as(@user)
    get pen_name_path(@pen_name)
    assert_template 'pen_names/show'
  end

  test "edit/update memo" do
    log_in_as(@other_user)
    get edit_pen_name_path(@pen_name)
    assert_redirected_to root_path

    patch pen_name_path(@pen_name), params: { pen_name: { name: @pen_name.name, description: "This is a test as a wrong user." } }
    assert_redirected_to root_path

    log_in_as(@user)
    get edit_pen_name_path(@pen_name)
    assert_template 'pen_names/edit'

    patch pen_name_path(@pen_name), params: { pen_name: { name: @pen_name, description: "This is a test." } }
    assert_redirected_to @user
  end

  test "delete memo" do
    log_in_as(@other_user)
    assert_difference '@user.pen_names.count', 0 do
      delete pen_name_path(@pen_name)
    end
    assert_redirected_to root_path

    log_in_as(@user)
    assert_difference '@user.pen_names.count', -1 do
      delete pen_name_path(@pen_name)
    end
    assert_redirected_to @user
  end

end
