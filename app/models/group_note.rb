class GroupNote < Note
  belongs_to :group
  validates :group_id, presence: true

  def to_user_note(user)
    member = self.group.get_user_member(user)
    if member && self.group.is_regular_member?(member) && (self.pen_name == member)
      note = self.becomes(Note)      
      note.update_attributes({type: "UserNote", user_id: user.id, group_id: nil})
    end
  end

  def can_show?(user)
    if self.is_web?
      true
    else
      member = self.group.get_user_member(user)
      (member && self.group.is_regular_member?(member)) || self.is_open?
    end
  end
  def can_set_point?(user)
    member = self.group.get_user_member(user)
    self.is_open? && member == nil
  end

  def can_update?(user)
    member = self.group.get_user_member(user)
    if self.pen_name
      member && self.group.is_regular_member?(member) && member == self.pen_name
    else
      member && self.group.is_leading_member?(member)
    end
  end
  def can_destroy?(user)
    member = self.group.get_user_member(user)
    if self.pen_name
      member && self.group.is_regular_member?(member) && member == self.pen_name
    else
      member && self.group.is_leading_member?(member)
    end
  end

  def can_move?(user)
    member = self.group.get_user_member(user)
    if self.pen_name
      member && self.group.is_regular_member?(member) && member == self.pen_name
    else
      false
    end
  end

  def can_control_memos?(user)
    member = self.group.get_user_member(user)
    if self.pen_name
      member && self.group.is_regular_member?(member) && member == self.pen_name
    else
      member && self.group.is_regular_member?(member)
    end
  end

  include Rails.application.routes.url_helpers
  def redirect_path
    group_group_note_path(self.group, self)
  end
end