class CreateMemos < ActiveRecord::Migration[5.1]
  def change
    create_table :memos do |t|

      # common
      t.integer :number
      t.references :note, foreign_key: true
      t.timestamps

      # text memo
      t.text :content

      # image memo
      t.string :picture

    end
  end
end
