class CreatePenNames < ActiveRecord::Migration[5.1]
  def change
    create_table :pen_names do |t|
      t.string :name
      t.text :outline
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
