class GroupNote < Note
  belongs_to :group
  validates :group_id, presence: true

  def can_setup?(user)
    member = self.group.get_user_member(user)
    self.group.is_leading_member?(member)
  end  
  def can_show?(user)
    self.group.get_user_member(user) or self.is_open?
  end
  def can_update?(user)
    member = self.group.get_user_member(user)
    self.group.is_regular_member?(member)
  end
  def can_destroy?(user)
    member = self.group.get_user_member(user)
    self.group.is_leading_member?(member)
  end

  include Rails.application.routes.url_helpers
  def redirect_path
    group_group_note_path(self.group, self)
  end
end