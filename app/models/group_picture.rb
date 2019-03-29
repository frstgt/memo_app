class GroupPicture < Picture
  belongs_to :group_note
  validates :group_note_id, presence: true
end
