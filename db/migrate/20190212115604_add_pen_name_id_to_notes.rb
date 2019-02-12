class AddPenNameIdToNotes < ActiveRecord::Migration[5.1]
  def change
    add_reference :notes, :pen_name, foreign_key: true
  end
end
