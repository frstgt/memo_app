class Note < ApplicationRecord
  belongs_to :user
  has_many :memos, dependent: :destroy

  default_scope -> { order(updated_at: :desc) }

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }

  def author
    if self.pen_name_id
      self.user.pen_names.find_by(id: self.pen_name_id).name
    else
      nil
    end
  end

end
