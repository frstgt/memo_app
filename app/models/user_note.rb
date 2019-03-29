class UserNote < Note
  belongs_to :user
  belongs_to :pen_name, optional: true
  has_many :user_memos, dependent: :destroy
  has_many :user_pictures, dependent: :destroy

  validates :user_id, presence: true

  def to_book
    if self.pen_name
      book = Book.create(title: self.title,
                      author: self.pen_name.name,
                      description: self.description,
                      picture: self.picture,
                      pen_name_id: self.pen_name_id,
                      group_id: nil)
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