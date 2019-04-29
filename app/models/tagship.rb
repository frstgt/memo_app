class Tagship < ApplicationRecord
  belongs_to :note, class_name: "Note"
  belongs_to :tag, class_name: "Tag"

  validates :note_id, presence: true
  validates :tag_id,  presence: true
end
