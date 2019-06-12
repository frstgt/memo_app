class AddNumberingToNotes < ActiveRecord::Migration[5.1]
  def change
    add_column :notes, :numbering, :integer, default: 0
  end
end
