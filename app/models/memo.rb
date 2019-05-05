class Memo < ApplicationRecord
  belongs_to :note, touch: true
  validates :note_id, presence: true

  default_scope -> { order(number: :asc) }

  validates :title, length: { maximum: 100 }
  validates :content, presence: true,
                      length: { maximum: 1000 }
  validates :number, presence: true

end
