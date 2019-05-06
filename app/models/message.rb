class Message < ApplicationRecord
  belongs_to :room, touch: true
  belongs_to :pen_name
  
  default_scope -> { order(updated_at: :desc) }
  
  validates :room_id,  presence: true
  validates :pen_name_id,  presence: true
  validates :content, presence: true, length: { maximum: 200 }

end
