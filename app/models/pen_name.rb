class PenName < ApplicationRecord
  belongs_to :user
  has_many :notes

  mount_uploader :picture, PictureUploader

  has_many :passive_memberships, class_name:  "Membership",
                                  foreign_key: "member_id",
                                  dependent:   :destroy
  has_many :groups, through: :passive_memberships,  source: :group

  # no default_scope

  validates :user_id, presence: true
  validates :name,  presence: true,
                    length: { minimum: 8, maximum: 32 },
                    uniqueness: true
  validates :description, length: { maximum: 1000 }
  validate  :picture_size

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
