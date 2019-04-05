class Message < ApplicationRecord
  belongs_to :group, dependent:   :destroy
  belongs_to :pen_name
  
  default_scope -> { order(updated_at: :desc) }
  
  validates :group_id,  presence: true
  validates :pen_name_id,  presence: true
  validates :content, length: { maximum: 200 }

end
