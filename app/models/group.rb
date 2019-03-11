class Group < ApplicationRecord
  has_many :active_memberships, class_name:  "Membership",
                                foreign_key: "group_id",
                                dependent:   :destroy
  has_many :members, through: :active_memberships, source: :member
  has_many :group_notes, dependent: :destroy

  default_scope -> { order(updated_at: :desc) }

  attr_accessor  :pen_name_id
  mount_uploader :picture, PictureUploader

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

  def join(pen_name, position=Membership::VISITOR)
    unless self.has_member?(pen_name.user)
      active_memberships.create(member_id: pen_name.id, position: position)
      true
    else
      false
    end
  end
  def unjoin(pen_name)
    membership = active_memberships.find_by(member_id: pen_name.id)
    if membership
      membership.destroy
      true
    else
      false
    end
  end

  def set_position(pen_name, position)
    membership = active_memberships.find_by(member_id: pen_name.id)
    if membership
      membership.update_attributes({position: position})
      true
    else
      false
    end
  end
  def get_position(pen_name)
    membership = active_memberships.find_by(member_id: pen_name.id)
    if membership
      Membership::POSITIONS[membership.position][0]
    else
      nil
    end
  end

  def leading_members
    member_ids = "SELECT member_id FROM memberships
                  WHERE group_id = :group_id AND position <= 2 ORDER BY position DESC"
    PenName.where("id IN (#{member_ids})", group_id: id)
  end
  def general_members
    member_ids = "SELECT member_id FROM memberships
                  WHERE group_id = :group_id AND position >= 3 ORDER BY position DESC"
    PenName.where("id IN (#{member_ids})", group_id: id)
  end

  def is_master?(pen_name)
    membership = active_memberships.find_by(member_id: pen_name.id)
    membership and membership.position == Membership::MASTER
  end
  def is_master_or_vice?(pen_name)
    membership = active_memberships.find_by(member_id: pen_name.id)
    membership and membership.position <= Membership::VICE
  end
  def is_master_or_vice_or_chief?(pen_name)
    membership = active_memberships.find_by(member_id: pen_name.id)
    membership and membership.position <= Membership::CHIEF
  end
  def is_master_or_vice_or_chief_or_common?(pen_name)
    membership = active_memberships.find_by(member_id: pen_name.id)
    membership and membership.position <= Membership::COMMON
  end

  def has_master?(user)
    user.pen_names.any? { |pen_name| self.is_master?(pen_name) }
  end
  def has_master_or_vice?(user)
    user.pen_names.any? { |pen_name| self.is_master_or_vice?(pen_name) }
  end
  def has_master_or_vice_or_chief?(user)
    user.pen_names.any? { |pen_name| self.is_master_or_vice_or_chief?(pen_name) }
  end
  def has_master_or_vice_or_chief_or_common?(user)
    user.pen_names.any? { |pen_name| self.is_master_or_vice_or_chief_or_common?(pen_name) }
  end
  def has_member?(user)
    user.pen_names.any? { |pen_name| self.members.include?(pen_name) }
  end
  
  def get_member(user)
    member = nil
    user.pen_names.each { |pen_name|
      if self.members.include?(pen_name)
        member = pen_name
      end
    }
    member
  end

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
