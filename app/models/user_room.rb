class UserRoom < Room
  belongs_to :user
  validates :user_id, presence: true

  def get_user_pen_name(user)
    pen_name = self.pen_name
    if pen_name and pen_name.user == user
      pen_name
    else
      nil
    end
  end

  def can_show?(user)
    (self.user == user) or self.is_open?
  end

  def can_update?(user)
    self.user == user
  end
  def can_destroy?(user)
    self.user == user
  end

  def can_control_messages?(user)
    (self.user == user) or self.is_open?
  end

  include Rails.application.routes.url_helpers
  def redirect_path
    user_room_path(self)
  end
end
