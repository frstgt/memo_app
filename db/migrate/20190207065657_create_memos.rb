class CreateMemos < ActiveRecord::Migration[5.1]
  def change
    create_table :memos do |t|

      # common
      t.integer :number
      t.string :type
      t.references :note, foreign_key: true
      t.timestamps

      # text memo
      t.text :content

      # image memo
      t.string :picture

    end
    add_index :memos, [:note_id, :number]
  end
end
