class Readership < ApplicationRecord
  belongs_to :reader, class_name: "User"
  belongs_to :note,  class_name: "Note"
  
  validates :reader_id, presence: true
  validates :note_id,  presence: true

  validates :point, presence: true, inclusion: { in: (-5..5) }

end