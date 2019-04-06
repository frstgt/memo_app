class Book < Note
  belongs_to :pen_name, optional: true
  belongs_to :group, optional: true
  has_many :book_memos, dependent: :destroy
  has_many :book_pictures, dependent: :destroy

  has_many :passive_readerships, class_name:  "Readership",
                                  foreign_key: "book_id",
                                  dependent:   :destroy
  has_many :readers, through: :passive_readerships,  source: :reader

  validates :author, presence: true, length: { maximum: 200 }

  def count_evaluations(condition)
    reader_ids = "SELECT reader_id FROM readerships
                  WHERE book_id = :book_id AND #{condition}"
    User.where("id IN (#{reader_ids})", book_id: id).count
  end
  def positive_count
    self.count_evaluations("evaluation > 0")
  end
  def negative_count
    self.count_evaluations("evaluation < 0")
  end

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

end
