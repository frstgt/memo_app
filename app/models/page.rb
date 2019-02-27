class Page < ApplicationRecord
  belongs_to :book

  default_scope -> { order(created_at: :asc) }

  mount_uploader :picture, PictureUploader

  validates :book_id, presence: true
  validates :content, presence: true,
                      length: { maximum: 1000 }
  validate  :picture_size

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end