class GroupNote < Note
  belongs_to :group
  has_many :group_memos, dependent: :destroy

  validates :group_id, presence: true
  validates :status,  presence: true

  def to_open
    self.update_attributes({status: 1})
  end
  def to_close
    self.update_attributes({status: 0})
  end
  def is_open?
    self.status == 1
  end

  def to_book
    if self.pen_name
      book = Book.create(title: self.title,
                      author: self.pen_name.name + " @ " + self.group.name,
                      description: self.description,
                      picture: self.picture,
                      pen_name_id: self.pen_name_id)
      self.user_memos.each { |memo|
        Page.create(title: memo.title,
                    content: memo.content,
                    picture: memo.picture,
                    book_id: book.id)
      }
      true
    else
      false
    end
  end

end