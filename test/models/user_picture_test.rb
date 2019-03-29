require 'test_helper'

class UserPictureTest < ActiveSupport::TestCase

  def setup
    @note = user_notes(:user1_note1)
#    @picture = @note.user_pictures.build(picture: nil)
  end

  test "should be valid" do
#    assert @picture.valid?
  end

end
