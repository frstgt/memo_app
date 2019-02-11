class RemoveUserFromMemos < ActiveRecord::Migration[5.1]
  def change
    remove_reference :memos, :user, foreign_key: true
  end
end
