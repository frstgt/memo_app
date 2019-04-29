class CreateTagships < ActiveRecord::Migration[5.1]
  def change
    create_table :tagships do |t|
      t.integer :note_id
      t.integer :tag_id

      t.timestamps
    end
    add_index :tagships, :note_id
    add_index :tagships, :tag_id
    add_index :tagships, [:note_id, :tag_id], unique: true
  end
end
