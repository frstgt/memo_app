class UserNote < Note
  belongs_to :user
  validates :user_id, presence: true

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

  def can_control_memos?(user)
    self.user == user
  end

  include Rails.application.routes.url_helpers
  def redirect_path
    user_note_path(self)
  end
end