class UserPicture < Picture
  belongs_to :user_note
  validates :user_note_id, presence: true
end
