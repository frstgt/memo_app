class RemoveIndexFromMemos < ActiveRecord::Migration[5.1]
  def change
    remove_index :memos, column: :number
  end
end
