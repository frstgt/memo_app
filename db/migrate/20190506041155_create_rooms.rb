class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.string :title
      t.text :outline
      t.references :group, foreign_key: true
      t.string :picture
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
