class UserNote < Note
  belongs_to :user
  validates :user_id, presence: true

  def to_group_note(group)
    member = group.get_user_member(self.user)
    if member and group.is_regular_member?(member) and (self.pen_name == member)
      note = self.becomes(Note)      
      note.update_attributes({type: "GroupNote", user_id: nil, group_id: group.id})
    end
  end

  def can_show?(user)
    self.user == user or self.is_open?
  end
  def can_set_point?(user)
    self.is_open? and self.user != user
  end

  def can_update?(user)
    self.user == user
  end
  def can_destroy?(user)
    self.user == user
  end
  
  def can_move?(user, group)
    if self.user == user
      member = group.get_user_member(user)
      if self.pen_name
        member and group.is_regular_member?(member) and (self.pen_name == member)
      else
        false
      end
    else
      false
    end
  end

  def can_control_memos?(user)
    self.user == user
  end

  include Rails.application.routes.url_helpers
  def redirect_path
    user_note_path(self)
  end
end