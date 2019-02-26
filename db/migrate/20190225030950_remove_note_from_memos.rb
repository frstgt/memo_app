class RemoveNoteFromMemos < ActiveRecord::Migration[5.1]
  def change
    remove_reference :memos, :note, foreign_key: true
  end
end
