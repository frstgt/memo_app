class AddBookIdToMemos < ActiveRecord::Migration[5.1]
  def change
    add_reference :memos, :book, foreign_key: true
  end
end
