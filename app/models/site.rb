class Site < ApplicationRecord

  validates :name,  presence: true
  validates :status,  presence: true

  mount_uploader :picture, PictureUploader
  validate  :picture_size

  ST_OPEN = 1
  ST_CLOSE = 0
  def is_open?
    self.status == ST_OPEN
  end

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
