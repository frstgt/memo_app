class Memo < ApplicationRecord

  default_scope -> { order(number: :asc) }

  mount_uploader :picture, PictureUploader

  validates :title, length: { maximum: 100 }
  validates :content, presence: true,
                      length: { maximum: 1000 }
  validates :number, presence: true
  validate  :picture_size

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
