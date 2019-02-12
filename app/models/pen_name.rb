class PenName < ApplicationRecord
  belongs_to :user

  default_scope -> { order(updated_at: :desc) }

  validates :user_id, presence: true
  validates :name,  presence: true,
                    length: { minimum: 8, maximum: 32 },
                    uniqueness: true
  validates :description, length: { maximum: 1000 }

end
