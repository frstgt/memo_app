class AddLayoutToMemos < ActiveRecord::Migration[5.1]
  def change
    add_column :memos, :title, :string
    add_column :memos, :layout, :integer
  end
end
