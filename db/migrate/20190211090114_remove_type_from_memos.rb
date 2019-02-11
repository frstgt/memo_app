class RemoveTypeFromMemos < ActiveRecord::Migration[5.1]
  def change
    remove_column :memos, :type, :string
  end
end
