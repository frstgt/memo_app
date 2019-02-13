class Group < ApplicationRecord
  has_many :active_memberships, class_name:  "Membership",
                                foreign_key: "group_id",
                                dependent:   :destroy
  has_many :members, through: :active_memberships, source: :member

  default_scope -> { order(updated_at: :desc) }

  validates :name,  presence: true,
                    length: { minimum: 8, maximum: 32 },
                    uniqueness: true
  validates :description, length: { maximum: 1000 }

  def position(pen_name)
    membership = active_memberships.find_by(member_id: pen_name.id)
    Membership::POSITIONS[membership.position]
  end
  
  def user_has_member?(user)
    user.pen_names.any? { |pen_name| self.members.include?(pen_name) }
  end

end
