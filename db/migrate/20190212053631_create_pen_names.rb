class CreatePenNames < ActiveRecord::Migration[5.1]
  def change
    create_table :pen_names do |t|
      t.string :name
      t.text :description
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :pen_names, [:user_id, :updated_at]
  end
end
