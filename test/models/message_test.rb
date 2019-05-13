require 'test_helper'

class MessageTest < ActiveSupport::TestCase

  def setup
    @group = groups(:group1)
    @pen_name = pen_names(:user1_pen_name1)
#    @message = @group.messages.build(content: "Test Message", pen_name_id: @pen_name.id)
  end

end
