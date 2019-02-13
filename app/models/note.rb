class Note < ApplicationRecord
  belongs_to :user
  belongs_to :pen_name, optional: true
  has_many :memos, dependent: :destroy

  default_scope -> { order(updated_at: :desc) }

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }

end
