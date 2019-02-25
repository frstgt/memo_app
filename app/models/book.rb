class Book < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :pen_name, optional: true
  has_many :pages, dependent: :destroy

  default_scope -> { order(created_at: :desc) }

  mount_uploader :picture, PictureUploader

  validates :title, presence: true, length: { maximum: 100 }
  validates :author, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }

  PRIVATE = 0
  SITE = 1
  PUBLIC = 2
  PROTECTIONS = ["Private", "Site", "Public"]
  validates :protection, presence: true,
                        inclusion: { in: [PRIVATE, SITE, PUBLIC] }

  validate  :picture_size

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
