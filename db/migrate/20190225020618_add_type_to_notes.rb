class AddTypeToNotes < ActiveRecord::Migration[5.1]
  def change
    add_column :notes, :type, :string
    add_reference :notes, :group, foreign_key: true
  end
end
