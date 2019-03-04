class CreateReaderships < ActiveRecord::Migration[5.1]
  def change
    create_table :readerships do |t|
      t.integer :reader_id
      t.integer :book_id
      t.integer :evaluation

      t.timestamps
    end
  end
end
