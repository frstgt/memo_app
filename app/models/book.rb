class Book < ApplicationRecord
  belongs_to :pen_name
  has_many :pages, dependent: :destroy
  has_many :passive_readerships, class_name:  "Readership",
                                  foreign_key: "book_id",
                                  dependent:   :destroy
  has_many :readers, through: :passive_readerships,  source: :reader

  mount_uploader :picture, PictureUploader

  validates :pen_name_id, presence: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :author, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }

  validate  :picture_size

  default_scope -> { order(created_at: :desc) }

  def set_evaluation(user, evaluation)
    readership = passive_readerships.find_by(reader_id: user.id)
    if readership
      readership.update_attributes({evaluation: evaluation})
    else
      passive_readerships.create(reader_id: user.id, evaluation: evaluation)
    end
  end
  def get_evaluation(user)
    readership = passive_readerships.find_by(reader_id: user.id)
    if readership
      readership.evaluation
    else
      0
    end
  end

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
