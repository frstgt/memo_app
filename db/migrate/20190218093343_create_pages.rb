class CreatePages < ActiveRecord::Migration[5.1]
  def change
    create_table :pages do |t|
      t.text :content
      t.string :picture
      t.references :book, foreign_key: true

      t.timestamps
    end
  end
end