class Picture < ApplicationRecord
  belongs_to :note, touch: true
  validates :note_id, presence: true

  default_scope -> { order(created_at: :asc) }

  mount_uploader :picture, PictureUploader

  validate  :picture_size

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
