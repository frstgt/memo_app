class UserRoomOpenValidator < ActiveModel::Validator
  def validate(record)
    if record.status == Room::ST_OPEN and record.pen_name == nil
      record.errors[:base] << "PenName must be valid when the Room is open"
    end
  end
end

class UserRoom < Room
  belongs_to :user
  validates :user_id, presence: true

  validates_with UserRoomOpenValidator

  def get_user_pen_name(user)
    pen_name = nil
    if self.pen_name and self.pen_name.user == user
      pen_name = self.pen_name
    else
      self.messages.each do |message|
        if message.pen_name and message.pen_name.user == user
          pen_name = message.pen_name
          break
        end
      end
      unless pen_name
        self.user.user_rooms do |room|
          room.messages.each do |message|
            if message.pen_name and message.pen_name.user == user
              pen_name = message.pen_name
              break
            end
          end
        end
      end
      pen_name
    end
    pen_name
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
