class Memo < ApplicationRecord
  belongs_to :note

  default_scope -> { order(number: :asc) }

  mount_uploader :picture, PictureUploader

  validates :note_id, presence: true
  validates :content, presence: true,
                      length: { maximum: 1000 }
  validates :number, presence: true

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
