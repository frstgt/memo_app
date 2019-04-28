class UserNote < Note
  belongs_to :user
  belongs_to :pen_name, optional: true
  has_many :user_memos, dependent: :destroy
  has_many :user_pictures, dependent: :destroy

  validates :user_id, presence: true
  validates :pen_name_id, presence: true

end