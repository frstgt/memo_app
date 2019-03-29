class UserMemo < Memo
  belongs_to :user_note, touch: true
  validates :user_note_id, presence: true
end