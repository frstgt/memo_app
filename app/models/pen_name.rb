class PenName < ApplicationRecord
  belongs_to :user
  has_many :books
  has_many :passive_memberships, class_name:  "Membership",
                                  foreign_key: "member_id",
                                  dependent:   :destroy
  has_many :groups, through: :passive_memberships,  source: :group

  mount_uploader :picture, PictureUploader

  # no default_scope

  validates :user_id, presence: true
  validates :name,  presence: true,
                    length: { minimum: 8, maximum: 32 },
                    uniqueness: true
  validates :description, length: { maximum: 1000 }
  validate  :picture_size
  validates :status,  presence: true

  def to_open
    self.update_attributes({status: 1})
  end
  def to_close
    self.update_attributes({status: 0})
  end
  def is_open?
    self.status == 1
  end

  def join(group)
    passive_memberships.create(group_id: group.id, position: Membership::VISITOR)
  end
  def unjoin(group)
    membership = passive_memberships.find_by(group_id: group.id)
    if membership
      membership.destroy
    end
  end

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
