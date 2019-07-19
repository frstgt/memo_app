class CreateSites < ActiveRecord::Migration[5.1]
  def change
    create_table :sites do |t|
      t.string :name, default: "memolet"
      t.text :outline
      t.string :picture
      t.integer :status, default: 1

      t.timestamps
    end
  end
end
