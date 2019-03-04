class RemoveLayoutFromMemos < ActiveRecord::Migration[5.1]
  def change
    remove_column :memos, :layout, :integer
  end
end
