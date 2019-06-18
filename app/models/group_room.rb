class GroupRoom < Room
  belongs_to :group
  validates :group_id, presence: true

  def get_user_pen_name(user)
    member = self.group.get_user_member(user)
    if member and member.user == user
      member
    else
      pen_name = nil
      self.messages.each do |message|
        if message.pen_name and message.pen_name.user == user
          pen_name = message.pen_name
          break
        end
      end
      pen_name
    end
  end

  def can_show?(user)
    member = self.group.get_user_member(user)
    (member and self.group.is_regular_member?(member)) or self.is_open?
  end

  def can_update?(user)
    member = self.group.get_user_member(user)
    if self.pen_name
      member and self.group.is_regular_member?(member) and member == self.pen_name
    else
      member and self.group.is_leading_member?(member)
    end
  end
  def can_destroy?(user)
    member = self.group.get_user_member(user)
    if self.pen_name
      member and self.group.is_regular_member?(member) and member == self.pen_name
    else
      member and self.group.is_leading_member?(member)
    end
  end

  def can_control_messages?(user)
    member = self.group.get_user_member(user)
    (member and self.group.is_regular_member?(member)) or self.is_open?
  end

  include Rails.application.routes.url_helpers
  def redirect_path
    group_group_room_path(self.group, self)
  end
end
