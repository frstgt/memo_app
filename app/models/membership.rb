class Membership < ApplicationRecord
  belongs_to :member, class_name: "PenName"
  belongs_to :group,  class_name: "Group"
  
  validates :member_id, presence: true
  validates :group_id,  presence: true

  POS_LEADER = 0
  POS_SUBLEADER = 1
  POS_COMMON = 2
  POS_VISITOR = 3
  POSITIONS = [
    ["Leader", POS_LEADER],
    ["Subleader", POS_SUBLEADER],
    ["Common", POS_COMMON],
    ["Visitor", POS_VISITOR],
  ]
  validates :position, presence: true,
                        inclusion: { in: [0,1,2,3] }

end
