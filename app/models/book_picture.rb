class BookPicture < Picture
  belongs_to :book
  validates :book_id, presence: true
end
