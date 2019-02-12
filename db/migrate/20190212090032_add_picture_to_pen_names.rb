class AddPictureToPenNames < ActiveRecord::Migration[5.1]
  def change
    add_column :pen_names, :picture, :string
    add_index :pen_names, :name, unique: true
  end
end
