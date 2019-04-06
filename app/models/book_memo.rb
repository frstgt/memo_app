class BookMemo < Memo
  belongs_to :book
  validates :book_id, presence: true
end
