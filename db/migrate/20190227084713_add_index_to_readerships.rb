class AddIndexToReaderships < ActiveRecord::Migration[5.1]
  def change
    add_index :readerships, :reader_id
    add_index :readerships, :book_id
    add_index :readerships, [:reader_id, :book_id], unique: true
  end
end
