class RemovePictureFromMemos < ActiveRecord::Migration[5.1]
  def change
    remove_column :memos, :picture, :string
  end
end
