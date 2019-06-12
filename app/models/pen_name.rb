class PenName < ApplicationRecord
  belongs_to :user
  has_many :user_notes, dependent: :destroy
  has_many :user_rooms, dependent: :destroy
  has_many :group_notes, dependent: :destroy
  has_many :group_rooms, dependent: :destroy

  has_many :passive_memberships, class_name:  "Membership",
                                  foreign_key: "member_id",
                                  dependent:   :destroy
  has_many :groups, through: :passive_memberships,  source: :group

  mount_uploader :picture, PictureUploader

  # no default_scope

  validates :user_id, presence: true
  validates :name,  presence: true,
                    length: { minimum: 8, maximum: 64 },
                    uniqueness: true
  validates :outline, length: { maximum: 1000 }
  validate  :picture_size

  validates :status,  presence: true

  ST_OPEN = 1
  ST_CLOSE = 0
  def is_open?
    self.status == ST_OPEN
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

  def search_groups(condition)
    group_ids = "SELECT group_id FROM memberships
                  WHERE member_id = :member_id AND #{condition} ORDER BY position DESC"
    Group.where("id IN (#{group_ids})", member_id: id)
  end
  def regular_groups
    self.search_groups("position <= #{Membership::POS_COMMON}")
  end

  def can_show?(user)
    self.user == user or self.is_open? or (self.keyword and self.keyword == user.keyword)
  end
  def can_update?(user)
    self.user == user
  end
  def can_destroy?(user)
    c1 = (self.user == user)
    c2 = (self.status != PenName::ST_OPEN)
    c3 = (self.groups.count == 0)
    c4 = (self.user_notes.where(status: Note::ST_OPEN).count == 0)
    c5 = (self.user_rooms.where(status: Room::ST_OPEN).count == 0)
    c6 = (self.group_notes.count == 0)
    c7 = (self.group_rooms.count == 0)
    c1 and c2 and c3 and c4 and c5 and c6 and c7
  end 

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
