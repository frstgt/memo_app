class GroupNote < Note
  belongs_to :group
  belongs_to :pen_name, optional: true
  has_many :group_memos, dependent: :destroy
  has_many :group_pictures, dependent: :destroy

  validates :group_id, presence: true

end