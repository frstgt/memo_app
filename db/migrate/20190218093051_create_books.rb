class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.text :description
      t.string :picture
      t.integer :protection
      t.references :user, foreign_key: true, index: true
      t.references :pen_name, foreign_key: true, index: true

      t.timestamps
    end
  end
end
