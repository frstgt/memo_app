class AddTypeToPictures < ActiveRecord::Migration[5.1]
  def change
    add_column :pictures, :type, :string
    add_reference :pictures, :group_note, foreign_key: true
    add_reference :pictures, :user_note, foreign_key: true
  end
end
