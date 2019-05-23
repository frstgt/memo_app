class Memo < ApplicationRecord
  belongs_to :note, touch: true

  default_scope -> { order(number: :asc) }

  validates :note_id, presence: true
  validates :title, length: { maximum: 100 }
  validates :content, length: { maximum: 1000 }
  validates :number, presence: true

end
