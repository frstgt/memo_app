class GroupNote < Note
  belongs_to :group
  has_many :group_memos, dependent: :destroy
  has_many :group_pictures, dependent: :destroy

  validates :group_id, presence: true
  validates :status,  presence: true

  ST_OPEN = 1
  ST_CLOSE = 0
  def to_open
    self.update_attributes({status: ST_OPEN})
  end
  def to_close
    self.update_attributes({status: ST_CLOSE})
  end
  def is_open?
    self.status == ST_OPEN
  end

  def to_book
    book = Book.create(title: self.title,
                    author: ((self.pen_name) ? self.pen_name.name + " @ " : "@ ") + self.group.name,
                    description: self.description,
                    picture: self.picture,
                    pen_name_id: self.pen_name_id,
                    group_id: self.group_id)
    self.user_memos.each { |memo|
      Page.create(title: memo.title,
                  content: memo.content,
                  picture: memo.picture,
                  book_id: book.id)
    }
  end

end