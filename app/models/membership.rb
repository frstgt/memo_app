class Membership < ApplicationRecord
  belongs_to :member, class_name: "PenName"
  belongs_to :group,  class_name: "Group"
  
  validates :member_id, presence: true
  validates :group_id,  presence: true

  MASTER = 0
  VICE = 1
  CHIEF = 2
  COMMON = 3
  VISITOR = 4
  INVALID = 100
  POSITIONS = [
    ["Master", MASTER],
    ["Vice", VICE],
    ["Chief", CHIEF],
    ["Common", COMMON],
    ["Visitor", VISITOR],
  ]
  validates :position, presence: true,
                        inclusion: { in: [MASTER, VICE, CHIEF, COMMON, VISITOR] }

end
