class UserNote < Note
  belongs_to :user
  validates :user_id, presence: true

  def can_create?(user)
    self.user == user
  end  
  def can_update?(user)
    self.user == user
  end

  include Rails.application.routes.url_helpers
  def redirect_path
    user_note_path(self)
  end
end