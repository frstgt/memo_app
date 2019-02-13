class PenName < ApplicationRecord
  belongs_to :user
  has_many :note

  has_many :passive_memberships, class_name:  "Membership",
                                  foreign_key: "member_id",
                                  dependent:   :destroy
  has_many :groups, through: :passive_memberships,  source: :group

  default_scope -> { order(updated_at: :desc) }

  validates :user_id, presence: true
  validates :name,  presence: true,
                    length: { minimum: 8, maximum: 32 },
                    uniqueness: true
  validates :description, length: { maximum: 1000 }

end
