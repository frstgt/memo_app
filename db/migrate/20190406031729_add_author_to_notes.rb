class AddAuthorToNotes < ActiveRecord::Migration[5.1]
  def change
    add_column :notes, :author, :string
  end
end
