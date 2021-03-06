require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User",
                     password: 'z8aKm$@3rTEp#+bs',
                     password_confirmation: 'z8aKm$@3rTEp#+bs')
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "name should not be too short" do
    @user.name = "a" * 7
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 65
    assert_not @user.valid?
  end

  test "name should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should satisfy some requirements" do
    password = "z8aKm$@3rTEp#+bs" # valid password
    @user.password = @user.password_confirmation = password
    assert @user.valid?

    password = "z8aKm$@3rTEp#+b" # 15chars
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?

    password = "z8aKm$@3rTEp#+bs" * 4 + "E" # 65chars
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?

    password = "z8akm$@3rtep#+bs" # no uppercase
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?
    password = "z8akm$@3rTep#+bs" # one uppercase
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?

    password = "Z8AKM$@3RTEP#+BS" # no lowercase
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?
    password = "Z8AKm$@3RTEP#+BS" # one lowercase
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?

    password = "zEaKm$@TrTEp#+bs" # no number
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?
    password = "zEaKm$@3rTEp#+bs" # one number
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?

    password = "z8aKmDA3rTEpSPbs" # no special character
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?
    password = "z8aKmDA3rTEp#Pbs" # one special character
    @user.password = @user.password_confirmation = password
    assert_not @user.valid?
  end

  test "associated notes should be destroyed" do
    skip "i should test it anywhere"

    @user.save
    @user.user_notes.create!(title: "Lorem ipsum")
    assert_difference 'UserNote.count', -1 do
      @user.destroy
    end
  end

end
