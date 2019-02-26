class GroupMemo < Memo
  belongs_to :group_note, touch: true

  validates :group_note_id, presence: true

end