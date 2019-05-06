class Room < ApplicationRecord
  belongs_to :group
  has_many :messages, dependent: :destroy

  default_scope -> { order(updated_at: :desc) }

  mount_uploader :picture, PictureUploader

  validates :title, presence: true, length: { maximum: 100 }
  validates :outline, length: { maximum: 1000 }
  validate  :picture_size

  validates :status,  presence: true

  ST_OPEN = 1
  ST_CLOSE = 0
  def to_open
    self.update_attributes({status: ST_OPEN})
  end
  def to_close
    self.update_attributes({status: ST_CLOSE})
  end
  def is_open?
    self.status == ST_OPEN
  end

  def can_setup?(user)
    member = self.group.get_user_member(user)
    member and self.group.is_leading_member?(member)
  end  
  def can_show?(user)
    self.group.get_user_member(user) or self.is_open?
  end
  def can_update?(user)
    member = self.group.get_user_member(user)
    member and self.group.is_regular_member?(member)
  end
  def can_destroy?(user)
    member = self.group.get_user_member(user)
    member and self.group.is_leading_member?(member)
  end

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
