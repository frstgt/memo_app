class Group < ApplicationRecord
  has_many :active_memberships, class_name:  "Membership",
                                foreign_key: "group_id",
                                dependent:   :destroy
  has_many :members, through: :active_memberships, source: :member
  has_many :group_notes, dependent: :destroy
  has_many :books
  has_many :messages

  default_scope -> { order(updated_at: :desc) }

  mount_uploader :picture, PictureUploader

  validates :name,  presence: true,
                    length: { minimum: 8, maximum: 32 },
                    uniqueness: true
  validates :description, length: { maximum: 1000 }
  validate  :picture_size
  validates :status,  presence: true

  attr_accessor  :pen_name_id

  def positive_count
    count = 0
    self.books.each do |book|
      count += book.positive_count
    end
    count
  end
  def negative_count
    count = 0
    self.books.each do |book|
      count += book.negative_count
    end
    count
  end

  ST_OPEN = 1
  ST_CLOSE = 0
  def to_open
    self.update_attributes({status: ST_OPEN})
  end
  def to_close
    self.update_attributes({status: ST_CLOSE})
  end
  def is_open?
    self.status == ST_OPEN
  end

  def first_leader(pen_name)
    if self.members.count == 0
      active_memberships.create(member_id: pen_name.id, position: Membership::POS_LEADER)
      true
    else
      false
    end
  end
  def change_leader
    members = self.leading_members
    if members.count > 2
      memberships = []
      members.each do |member|
        membership = active_memberships.find_by(member_id: member.id)
        memberships.append(membership)
      end
      memberships.sort_by! do |member|
        [member.position, member.updated_at]
      end
      memberships[0].update_attributes({position: Membership::POS_SUBLEADER})
      memberships[1].update_attributes({position: Membership::POS_LEADER})
      true
    else
      false
    end
  end

  def join(pen_name)
    unless self.get_user_member(pen_name.user)
      active_memberships.create(member_id: pen_name.id, position: Membership::POS_VISITOR)
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

  def set_position(member, position)
    membership = active_memberships.find_by(member_id: member.id)
    if membership
      membership.update_attributes({position: position})
      true
    else
      false
    end
  end
  def get_position_id(pen_name)
    membership = active_memberships.find_by(member_id: pen_name.id)
    if membership
      membership.position
    else
      Membership::INVALID
    end
  end
  def get_position_name(pen_name)
    position_id = self.get_position_id(pen_name)
    if position_id <= Membership::POS_VISITOR
      Membership::POSITIONS[position_id][0]
    else
      "Invalid"
    end
  end

  def search_members(condition)
    member_ids = "SELECT member_id FROM memberships
                  WHERE group_id = :group_id AND #{condition} ORDER BY position DESC"
    PenName.where("id IN (#{member_ids})", group_id: id)
  end
  def leading_members
    self.search_members("position <= #{Membership::POS_SUBLEADER}")
  end
  def general_members
    self.search_members("position >= #{Membership::POS_COMMON}")
  end
  def regular_members
    self.search_members("position <= #{Membership::POS_COMMON}")
  end
  def irregular_members
    self.search_members("position = #{Membership::POS_VISITOR}")
  end

  def is_leader?(pen_name)
    membership = active_memberships.find_by(member_id: pen_name.id)
    membership and membership.position == Membership::POS_LEADER
  end
  def is_leading_member?(pen_name) # leader, subleader
    membership = active_memberships.find_by(member_id: pen_name.id)
    membership and membership.position <= Membership::POS_SUBLEADER
  end
  def is_general_member?(pen_name) # common, visitor
    membership = active_memberships.find_by(member_id: pen_name.id)
    membership and membership.position >= Membership::POS_COMMON
  end
  def is_regular_member?(pen_name) # leader, subleader, common
    membership = active_memberships.find_by(member_id: pen_name.id)
    membership and membership.position <= Membership::POS_COMMON
  end
  def is_iregular_member?(pen_name) # visitor
    membership = active_memberships.find_by(member_id: pen_name.id)
    membership and membership.position == Membership::POS_VISITOR
  end
  def is_member?(pen_name)
    membership = active_memberships.find_by(member_id: pen_name.id)
    if membership
      true
    else
      false
    end
  end

  def self.get_user_groups(user)
    groups = []
    user.pen_names.each do |pen_name|
      groups += pen_name.groups
    end
    groups
  end
  def get_user_member(user)
    member = nil
    self.members.each { |pen_name|
      if pen_name.user == user
        member = pen_name
        break
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
