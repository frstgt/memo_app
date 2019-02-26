class UserNote < Note
  belongs_to :user
  has_many :user_memos, dependent: :destroy

  validates :user_id, presence: true

end