class Group < ApplicationRecord
  has_many :active_memberships, class_name:  "Membership",
                                foreign_key: "group_id",
                                dependent:   :destroy
  has_many :members, through: :active_memberships, source: :member

  has_many :group_notes, dependent: :destroy
  has_many :group_rooms, dependent: :destroy

  default_scope -> { order(updated_at: :desc) }

  mount_uploader :picture, PictureUploader

  validates :name,  presence: true,
                    length: { minimum: 8, maximum: 64 },
                    uniqueness: true
  validates :outline, length: { maximum: 1000 }
  validate  :picture_size

  validates :status,  presence: true

  attr_accessor  :leader_id

  ST_OPEN = 1
  ST_CLOSE = 0
  def is_open?
    self.status == ST_OPEN
  end

  def set_leader(pen_name)
    if self.members.count == 0
      active_memberships.create(member_id: pen_name.id, position: Membership::POS_LEADER)
    else
      if (pen_name != self.leader) and self.is_regular_member?(pen_name)
        leader_membership = active_memberships.find_by(position: Membership::POS_LEADER)
        member_membership = active_memberships.find_by(member_id: pen_name.id)

        leader_membership.update_attributes({position: Membership::POS_SUBLEADER})
        member_membership.update_attributes({position: Membership::POS_LEADER})
      end
    end
  end
  def leader
    membership = active_memberships.find_by(position: Membership::POS_LEADER)
    (membership) ? membership.member : nil
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
    if pen_name
      membership = active_memberships.find_by(member_id: pen_name.id)
      if membership
        membership.position
      else
        nil
      end
    else
      nil
    end
  end
  def get_position_name(pen_name)
    position_id = self.get_position_id(pen_name)
    if position_id and position_id <= Membership::POS_VISITOR
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
    pen_name == self.leader
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
  def is_irregular_member?(pen_name) # visitor
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

  def get_user_pen_name(user)
    pen_name = nil
    self.group_rooms do |room|
      room.messages.each do |message|
        if message.pen_name and message.pen_name.user == user
          pen_name = message.pen_name
          break
        end
      end
    end
    pen_name
  end

  def get_user_member(user)
    member = nil
    self.members.each do |pen_name|
      if pen_name.user == user
        member = pen_name
        break
      end
    end
    member
  end

  def can_show?(user)
    if user
      user_member = self.get_user_member(user)
      user_member || self.is_open? || (self.keyword && self.keyword == user.keyword)
    else
      false
    end
  end
  def can_update?(user)
    user_member = self.get_user_member(user)
    user_member and (user_member == self.leader)
  end
  def can_destroy?(user)
    user_member = self.get_user_member(user)
    c1 = (user_member and (user_member == self.leader))
    c2 = (self.members.count == 1)
    c3 = (self.status != Group::ST_OPEN)
    c4 = (self.group_notes.where(status: Note::ST_OPEN).count == 0)
    c5 = (self.group_rooms.where(status: Room::ST_OPEN).count == 0)
    c1 and c2 and c3 and c4 and c5
  end 

  def can_join?(user)
    user_member = self.get_user_member(user)
    (user_member == nil) and (self.keyword and self.keyword == user.keyword)
  end
  def can_unjoin?(user)
    user_member = self.get_user_member(user)
    c1 = (user_member and (user_member != self.leader))
    c2 = (user_member and user_member.group_notes.count == 0)
    c3 = (user_member and user_member.group_rooms.count == 0)
    c1 and c2 and c3
  end
  def can_set_position?(user, group_member, to_pos)
    user_member = self.get_user_member(user)
    do_pos = self.get_position_id(user_member)
    from_pos = self.get_position_id(group_member)
    user_member and (do_pos <= Membership::POS_SUBLEADER) and do_pos < from_pos and do_pos < to_pos and from_pos != to_pos
  end

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
