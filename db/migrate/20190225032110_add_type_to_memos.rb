class AddTypeToMemos < ActiveRecord::Migration[5.1]
  def change
    add_column :memos, :type, :string
    add_reference :memos, :group_note, foreign_key: true
    add_reference :memos, :user_note, foreign_key: true
    add_index :memos, [:user_note_id, :number]
    add_index :memos, [:group_note_id, :number]
  end
end
