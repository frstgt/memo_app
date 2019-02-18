class AddPictureToNotes < ActiveRecord::Migration[5.1]
  def change
    add_column :notes, :picture, :string
  end
end
