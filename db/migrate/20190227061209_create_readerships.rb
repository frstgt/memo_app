class CreateReaderships < ActiveRecord::Migration[5.1]
  def change
    create_table :readerships do |t|
      t.integer :reader_id
      t.integer :note_id
      t.integer :point

      t.timestamps
    end
    add_index :readerships, :reader_id
    add_index :readerships, :note_id
    add_index :readerships, [:reader_id, :note_id], unique: true
  end
end
