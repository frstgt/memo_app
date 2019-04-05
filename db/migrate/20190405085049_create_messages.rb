class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.text :content
      t.references :group, foreign_key: true
      t.references :pen_name, foreign_key: true

      t.timestamps
    end
  end
end
