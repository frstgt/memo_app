class GroupNote < Note
  belongs_to :group
  has_many :group_memos, dependent: :destroy

  validates :group_id, presence: true

end