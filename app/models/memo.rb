class Memo < ApplicationRecord

  default_scope -> { order(number: :asc) }

  validates :title, length: { maximum: 100 }
  validates :content, presence: true,
                      length: { maximum: 1000 }
  validates :number, presence: true

end
