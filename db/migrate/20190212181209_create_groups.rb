class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.text :outline
      t.string :picture

      t.timestamps
    end
    add_index :groups, :name, unique: true
  end
end
